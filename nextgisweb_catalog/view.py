# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from nextgisweb.resource import Widget, resource_factory
from nextgisweb.dynmenu import DynItem, Label, Link

from .model import Catalog
from .util import _


class BasemapLayerWidget(Widget):
    resource = Catalog
    operation = ('create', 'update')
    amdmod = 'ngw-catalog/ItemWidget'


def setup_pyramid(comp, config):

    def display(obj, request):
        pass

    config.add_route(
        'catalog.display', '/resource/{id:\d+}/catalog/display',
        factory=resource_factory, client=('id', )
    ).add_view(display, context=Catalog,)

    class DisplayMenu(DynItem):
        def build(self, args):
            if isinstance(args.obj, Catalog):
                yield Label('catalog', _("Catalog"))

                yield Link(
                    'catalog/display', _("Display"),
                    self._url())

        def _url(self):
            return lambda (args): args.request.route_url(
                'catalog.display', id=args.obj.id)

    Catalog.__dynmenu__.add(DisplayMenu())