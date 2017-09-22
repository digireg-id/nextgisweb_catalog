<div id="catalogLayers">
    %for layer_info in ui_catalog_items['layers']:
        <div class="layer-row">
            <div class="layer-row-type">
                <span class="text-withIcon">
                    <span class="text-withIcon__icon">
                        <svg class="text-withIcon__pic svgIcon-vector_layer"> <use
                                xmlns:xlink="http://www.w3.org/1999/xlink"
                                xlink:href="${request.static_url('nextgisweb:static/svg/svg-symbols.svg')}#vector_layer"></use>
                        </svg>
                    </span>
                </span>
            </div>
            <div class="layer-detail">
                <a href="${request.route_url('catalog.layer', layer_id=layer_info['id'], id=catalog.id)}">
                    <span class="layer-title">${layer_info['title']}</span>
                </a>
                <br/>
                <span class="layer-description">${layer_info['description'] | n}</span>
            </div>
            <div class="layer-actions pre-load-widget">
                <div data-dojo-type="dijit/form/Button"
                     data-dojo-props="showLabel:false, iconClass:'icon icon-map'">
                    <script type="dojo/connect" data-dojo-event="onClick">
                        window.location = "#";
                    </script>
                </div>
                <div data-dojo-type="dijit/form/DropDownButton"
                     data-dojo-props="showLabel:false, iconClass:'icon icon-link'">
                    <a class="material-icons icon-arrowDownward" id="la-${layer_info['layer_resource_id']}"></a>
                    <div data-dojo-type="dijit/TooltipDialog" class="layer-action">
                        <a class="layer-action"
                           href="">WFS</a>
                        <a class="layer-action"
                           href="">WMS</a>
                    </div>
                </div>
                <div data-dojo-type="dijit/form/DropDownButton"
                     data-dojo-props="showLabel:false, iconClass:'icon icon-download-alt'">
                    <a class="material-icons icon-arrowDownward" id="la-${layer_info['layer_resource_id']}"></a>
                    <div data-dojo-type="dijit/TooltipDialog">
                        <a class="layer-action"
                           href="${request.route_url('feature_layer.geojson', id=layer_info['layer_resource_id'])}">JSON</a>
                        <a class="layer-action"
                           href="${request.route_url('feature_layer.csv', id=layer_info['layer_resource_id'])}">CSV</a>
                    </div>
                </div>
            </div>
        </div>
    %endfor
</div>