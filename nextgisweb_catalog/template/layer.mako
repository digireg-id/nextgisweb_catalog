<%inherit file='nextgisweb:templates/base.mako' />

<%! from nextgisweb.pyramid.util import _ %>
<%! from platform import platform %>
<%! import sys %>

<%def name="head()">
    <link href="${request.route_url('amd_package', subpath='ngw-catalog/catalog/catalog.css')}"
          rel="stylesheet" media="screen"/>
    <link href="${request.route_url('amd_package', subpath='ngw-catalog/catalog/layer.css')}"
          rel="stylesheet" media="screen"/>

    <script>
        require([
            "dojo/ready",
            "dojo/parser",
            "dijit/registry",
            "ngw-feature-layer/FeatureGrid",
            "dijit/layout/ContentPane",
            "dijit/layout/BorderContainer"
        ], function (ready, parser, registry) {
            ready(function () {
                parser.parse();
            });
        });
    </script>
</%def>


<div id="layerContainer">
    <div id="mainBorderContainer" data-dojo-type="dijit/layout/BorderContainer" style="width: 100%; height: 100%">
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'top', gutters: false">
            <div id="title" class="title">
                <h1>${title}</h1>
            </div>
        </div>
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'leading', gutters: false, splitter:true"
             style="width: 30%;">
            <h2>${layer_catalog_item.display_name}</h2>
            <span>${layer_catalog_item.description}</span>
            <span class="text-withIcon">
                <span class="text-withIcon__icon">
                    <svg class="text-withIcon__pic svgIcon-vector_layer"> <use
                            xmlns:xlink="http://www.w3.org/1999/xlink"
                            xlink:href="${request.static_url('nextgisweb:static/svg/svg-symbols.svg')}#vector_layer"></use>
                    </svg>
                </span>
            </span>
            ${tr(_("Vector layer"))}
            <%include file="nextgisweb:resource/template/section_summary.mako"/>
        </div>
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'center', gutters: false, splitter:true">
            <div style="width: 100%; height: 100%">
                <div data-dojo-type="dijit/layout/TabContainer" style="width: 100%; height: 100%;">
                    %if layer_catalog_item.layer_webmap_id:
                        <div data-dojo-type="dijit/layout/ContentPane" title="${tr(_("Map"))}"
                             data-dojo-props="selected:true"></div>
                    %endif
                    <div data-dojo-type="dijit/layout/ContentPane" title="${tr(_("Feature table"))}">
                        <div data-dojo-type="ngw-feature-layer/FeatureGrid"
                             data-dojo-props="layerId: ${obj.id}" style="width: 100%; height: 100%; padding: 0"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


