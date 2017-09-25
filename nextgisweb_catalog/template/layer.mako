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
            "dojo/parser",
            "dojo/query",
            "dojo/dom-class",
            "dojo/_base/array",
            "dojo/dom-construct",
            "dijit/TooltipDialog",
            "dijit/form/DropDownButton",
            "dijit/form/TextBox",
            "dijit/form/Button",
            "ngw-feature-layer/FeatureGrid",
            "dijit/layout/ContentPane",
            "dijit/layout/BorderContainer",
            "dojo/domReady!"
        ], function (parser, query, domClass, array, domConstruct) {
            parser.parse().then(function (instances) {
                var preLoadWidgets = query(".pre-load-widget");
                array.forEach(preLoadWidgets, function (div) {
                    domClass.remove(div, "pre-load-widget");
                });
                var tinyUrl = "${request.route_url('webmap.display.tiny', id=layer_catalog_item.layer_webmap_id)}";
                var iframe = '<iframe src="' + tinyUrl + '"></iframe>';
                var iframeNode = domConstruct.toDom(iframe);
                domConstruct.place(iframeNode, 'mapContainer');
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
        <div data-dojo-type="dijit/layout/ContentPane"
             class="layer-info-panel"
             data-dojo-props="region:'leading', gutters: false, splitter:true"
             style="width: 30%;">
            <div class="pre-load-widget">
                <h2>${layer_catalog_item.display_name}</h2>
                <div class="layer-type">
                    <span class="text-withIcon">
                        <span class="text-withIcon__icon">
                            <svg class="text-withIcon__pic svgIcon-vector_layer"> <use
                                    xmlns:xlink="http://www.w3.org/1999/xlink"
                                    xlink:href="${request.static_url('nextgisweb:static/svg/svg-symbols.svg')}#vector_layer"></use>
                            </svg>
                        </span>
                        ${tr(_("Vector layer"))}
                    </span>
                </div>
                <span class="layer-description">${layer_catalog_item.description}</span>
                <div class="layer-details">
                    <h3>${tr(_("Layer details"))}</h3>
                    <%include file="nextgisweb:resource/template/section_summary.mako"/>
                </div>
                <div class="layer-actions pre-load-widget">
                    %if layer_catalog_item.layer_wms_id or layer_catalog_item.layer_wfs_id:
                        <div data-dojo-type="dijit/form/DropDownButton"
                             data-dojo-props="label:'${tr(_("Services"))}'">
                            <a id="la-${layer_catalog_item.layer_resource_id}"></a>
                            <div data-dojo-type="dijit/TooltipDialog" class="layer-action">
                                %if layer_catalog_item.layer_wms_id:
                                    <a class="layer-action"
                                       href="${request.route_url('resource.item', id=layer_catalog_item.layer_wms_id)}">WMS</a>
                                %endif
                                %if layer_catalog_item.layer_wfs_id:
                                    <a class="layer-action"
                                       href="${request.route_url('resource.item', id=layer_catalog_item.layer_wfs_id)}">WFS</a>
                                %endif
                            </div>
                        </div>
                    %endif
                    <div data-dojo-type="dijit/form/DropDownButton"
                         data-dojo-props="label:'${tr(_("Download"))}'">
                        <a id="la-${layer_catalog_item.layer_resource_id}"></a>
                        <div data-dojo-type="dijit/TooltipDialog">
                            <a class="layer-action"
                               href="${request.route_url('feature_layer.geojson', id=layer_catalog_item.layer_resource_id)}">JSON</a>
                            <a class="layer-action"
                               href="${request.route_url('feature_layer.csv', id=layer_catalog_item.layer_resource_id)}">CSV</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'center', gutters: false, splitter:true">
            <div style="width: 100%; height: 100%">
                <div data-dojo-type="dijit/layout/TabContainer" style="width: 100%; height: 100%;">
                    %if layer_catalog_item.layer_webmap_id:
                        <div data-dojo-type="dijit/layout/ContentPane" title="${tr(_("Map"))}"
                             data-dojo-props="selected:true">
                            <div id="mapContainer"></div>
                        </div>
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


