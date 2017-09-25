<div id="catalogLayers" class="layer-cards">
    %for layer_info in ui_catalog_items['layers']:

        <div class="layer-card card">
            <div class="layer-card__container container">
                <div class="layer-card__actions layer-actions pre-load-widget">
                    %if layer_info['layer_catalog_item'].layer_webmap_id:
                        <div class="layer-card__action button--icon material-icons"
                             data-dojo-type="dijit/form/Button"
                             data-dojo-props="label:'map'">
                        <script type="dojo/connect" data-dojo-event="onClick">
                            window.location = "${request.route_url('webmap.display', id=layer_info['layer_catalog_item'].layer_webmap_id)}";
                        </script>
                    </div>
                    %endif
                    %if layer_info['layer_catalog_item'].layer_wms_id or layer_info['layer_catalog_item'].layer_wfs_id:
                        <div class="layer-card__action button--icon material-icons"
                             data-dojo-type="dijit/form/DropDownButton"
                             data-dojo-props="label:'link'">
                            <div data-dojo-type="dijit/TooltipDialog" class="layer-action">
                                %if layer_info['layer_catalog_item'].layer_wms_id:
                                    <a class="layer-action"
                                       href="${request.route_url('resource.item', id=layer_info['layer_catalog_item'].layer_wms_id)}">WMS</a>
                                %endif
                                %if layer_info['layer_catalog_item'].layer_wfs_id:
                                    <a class="layer-action"
                                       href="${request.route_url('resource.item', id=layer_info['layer_catalog_item'].layer_wfs_id)}">WFS</a>
                                %endif
                            </div>
                        </div>
                    %endif
                    <div class="layer-card__action button--icon material-icons"
                         data-dojo-type="dijit/form/DropDownButton"
                         data-dojo-props="label:'file_download'">
                        <div data-dojo-type="dijit/TooltipDialog">
                            <a class="layer-action"
                               href="${request.route_url('feature_layer.geojson', id=layer_info['layer_resource_id'])}">JSON</a>
                            <a class="layer-action"
                               href="${request.route_url('feature_layer.csv', id=layer_info['layer_resource_id'])}">CSV</a>
                        </div>
                    </div>
                </div>
                <svg class="layer-card__icon text-withIcon__pic svgIcon-vector_layer"> <use
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                        xlink:href="${request.static_url('nextgisweb:static/svg/svg-symbols.svg')}#vector_layer"></use>
                </svg>
                <div class="layer-card__title">${layer_info['title']}</div>
                    <span class="layer-description">${layer_info['description'] | n}</span>
            </div>

            <a class="layer-card__link" href="${request.route_url('catalog.layer', layer_id=layer_info['id'], id=catalog.id)}"></a>
        </div>
    %endfor
</div>