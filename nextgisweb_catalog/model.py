# -*- coding: utf-8 -*-
from __future__ import unicode_literals, print_function, absolute_import
from sqlalchemy.ext.orderinglist import ordering_list

from nextgisweb import db
from nextgisweb.models import declarative_base
from nextgisweb.resource import (
    Resource,
    Scope,
    Permission,
    ResourceScope,
    Serializer,
    SerializedProperty as SP,
    ResourceGroup)

from .util import _

Base = declarative_base()


class CatalogScope(Scope):
    identity = 'catalog'
    label = _("Catalog")

    display = Permission(_("Display"))


class Catalog(Base, Resource):
    identity = 'catalog'
    cls_display_name = _("Catalog")

    __scope__ = CatalogScope

    root_item_id = db.Column(db.ForeignKey('catalog_item.id'), nullable=False)
    root_item = db.relationship('CatalogItem', cascade='all')

    @classmethod
    def check_parent(cls, parent):
        return isinstance(parent, ResourceGroup)


class CatalogItem(Base):
    __tablename__ = 'catalog_item'

    id = db.Column(db.Integer, primary_key=True)
    parent_id = db.Column(db.Integer, db.ForeignKey('catalog_item.id'))
    item_type = db.Column(db.Enum('root', 'group', 'layer'), nullable=False)
    position = db.Column(db.Integer)
    display_name = db.Column(db.Unicode)
    description = db.Column(db.Unicode)
    layer_enabled = db.Column(db.Boolean)
    layer_wms_id = db.Column(db.ForeignKey(Resource.id))
    layer_wfs_id = db.Column(db.ForeignKey(Resource.id))
    layer_webmap_id = db.Column(db.ForeignKey(Resource.id))

    parent = db.relationship(
        'CatalogItem', remote_side=id, backref=db.backref(
            'children', order_by=position, cascade='all, delete-orphan',
            collection_class=ordering_list('position')))

    def to_dict(self):
        if self.item_type in ('root', 'group'):
            children = list(self.children)
            sorted(children, key=lambda c: c.position)

            if self.item_type == 'root':
                return dict(
                    item_type=self.item_type,
                    children=[i.to_dict() for i in children],
                )

            elif self.item_type == 'group':
                return dict(
                    item_type=self.item_type,
                    display_name=self.display_name,
                    description=self.description,
                    children=[i.to_dict() for i in children],
                )

        elif self.item_type == 'layer':
            return dict(
                item_type=self.item_type,
                display_name=self.display_name,
                description=self.description,
                layer_enabled=self.layer_enabled,
                layer_webmap_id=self.layer_webmap_id,
                layer_wms_id=self.layer_wms_id,
                layer_wfs_id=self.layer_wfs_id
            )

    def from_dict(self, data):
        assert data['item_type'] == self.item_type
        if data['item_type'] in ('root', 'group') and 'children' in data:
            self.children = []
            for i in data['children']:
                child = CatalogItem(parent=self, item_type=i['item_type'])
                child.from_dict(i)
                self.children.append(child)

        for a in ('display_name',
                  'description',
                  'layer_enabled',
                  'layer_webmap_id',
                  'layer_wms_id',
                  'layer_wfs_id'):

            if a in data:
                setattr(self, a, data[a])


PR_READ = ResourceScope.read
PR_UPDATE = ResourceScope.update


class _root_item_attr(SP):

    def getter(self, srlzr):
        return srlzr.obj.root_item.to_dict()

    def setter(self, srlzr, value):
        if srlzr.obj.root_item is None:
            srlzr.obj.root_item = CatalogItem(item_type='root')

        srlzr.obj.root_item.from_dict(value)


class CatalogSerializer(Serializer):
    identity = Catalog.identity
    resclass = Catalog

    root_item = _root_item_attr(read=PR_READ, write=PR_UPDATE)