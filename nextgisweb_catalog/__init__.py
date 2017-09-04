# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from nextgisweb.component import Component, require

from .model import Base
from .util import COMP_ID


class CatalogComponent(Component):
    identity = COMP_ID
    metadata = Base.metadata

    def setup_pyramid(self, config):
        from . import view
        view.setup_pyramid(self, config)

def pkginfo():
    return dict(components=dict(
        catalog='nextgisweb_catalog'))


def amd_packages():
    return (
        ('ngw-catalog', 'nextgisweb_catalog:amd/ngw-catalog'),
)
