# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from nextgisweb.resource import Widget, resource_factory
from nextgisweb.dynmenu import DynItem, Label, Link
from nextgisweb.vector_layer import VectorLayer

from .model import Catalog, CatalogItem
from .util import _


class BasemapLayerWidget(Widget):
    resource = Catalog
    operation = ('create', 'update')
    amdmod = 'ngw-catalog/ItemWidget'


def setup_pyramid(comp, config):
    build_routes(config)

    class DisplayMenu(DynItem):
        def build(self, args):
            if isinstance(args.obj, Catalog):
                yield Label('catalog', _("Catalog"))

                yield Link(
                    'catalog', _("Display"),
                    self._url())

        def _url(self):
            return lambda (args): args.request.route_url(
                'catalog.display', id=args.obj.id)

    Catalog.__dynmenu__.add(DisplayMenu())


def build_routes(config):
    config.add_route(
        'catalog.display', '/resource/{id:\d+}/catalog',
        factory=resource_factory, client=('id',)
    ).add_view(catalog_display, context=Catalog, renderer='nextgisweb_catalog:template/catalog.mako')

    config.add_route(
        'catalog.layer', '/resource/{id:\d+}/layer/{layer_id:\d+}',
        factory=resource_factory, client=('id', 'layer_id')
    ).add_view(layer_display, context=Catalog, renderer='nextgisweb_catalog:template/layer.mako')

    config.add_route(
        'catalog.group', '/resource/{id:\d+}/group/{group_id:\d+}',
        factory=resource_factory, client=('id', 'group_id')
    ).add_view(group_display, context=Catalog, renderer='nextgisweb_catalog:template/group.mako')


def catalog_display(obj, request):
    return dict(
        title=obj.display_name,
        catalog=obj,
        custom_layout=True,
        ui_catalog_items=get_ui_catalog_items(obj.root_item)
    )


def get_empty_ui_catalog_items():
    return {
        'groups': [],
        'layers': []
    }


def get_ui_catalog_items(catalog_item):
    ui_catalog_items = get_empty_ui_catalog_items()

    if not catalog_item or not catalog_item.children:
        return ui_catalog_items

    children = catalog_item.children

    for ch in children:
        if ch.item_type == 'group':
            group_info = get_group_info(ch)
            ui_catalog_items['groups'].append(group_info)

    last_layers = get_last_layers()
    ui_catalog_items['layers'] = map(make_layer_info, last_layers)

    return ui_catalog_items


def make_layer_info(layer_catalog_item):
    return {
        'id': layer_catalog_item.id,
        'title': layer_catalog_item.display_name,
        'description': layer_catalog_item.description,
        'layer_resource_id': layer_catalog_item.layer_resource_id,
        'layer_catalog_item': layer_catalog_item
    }


def get_last_layers():
    last_layers = CatalogItem.query()\
        .filter(CatalogItem.item_type == 'layer')\
        .order_by(CatalogItem.id.desc())\
        .limit(5)\
        .all()

    return last_layers


def get_group_info(group_catalog_item):
    count_children = len(group_catalog_item.children)
    return {
        'id': group_catalog_item.id,
        'title': group_catalog_item.display_name,
        'description': group_catalog_item.description,
        'count': count_children
    }


def layer_display(catalog, request):
    layer_id = request.matchdict['layer_id']
    layer_catalog_item = CatalogItem.query().filter(CatalogItem.id == layer_id).one()
    resource_id = layer_catalog_item.layer_resource_id
    vector_layer = VectorLayer.query().filter(VectorLayer.id == resource_id).one()

    return dict(
        title=catalog.display_name,
        obj=vector_layer,
        catalog=catalog,
        layer_catalog_item=layer_catalog_item,
        custom_layout=True
    )


def get_ui_catalog_items_by_group(group_catalog_item):
    ui_catalog_items = get_empty_ui_catalog_items()
    layers_by_group = CatalogItem.query().filter(CatalogItem.parent_id == group_catalog_item.id).all()
    ui_catalog_items['layers'] = map(make_layer_info, layers_by_group)
    return ui_catalog_items


def group_display(obj, request):
    group_id = request.matchdict['group_id']
    group_catalog_item = CatalogItem.query().filter(CatalogItem.id == group_id).one()
    ui_catalog_items = get_ui_catalog_items_by_group(group_catalog_item)

    return dict(
        title=obj.display_name,
        catalog=obj,
        group_catalog_item=group_catalog_item,
        custom_layout=True,
        ui_catalog_items=ui_catalog_items
    )
