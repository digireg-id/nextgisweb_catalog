<div id="catalogGroups" class="container grid-list-xl">
    <div class="layout row wrap">
        %for group_info in ui_catalog_items['groups']:
            <div class="flex xs4">
                <a class="group-card__link" href="${request.route_url('catalog.group', id=catalog.id, group_id=group_info['id'])}">
                    <div class="group-card card">
                        <div class="container fill-height fluid">
                            <div class="group-card__title">
                                ${group_info['title']}
                            </div>
                            <div class="group-card__description">${group_info['description'] | n}</div>
                            <div class="group-card__layers">
                                <div class="group-card__layers-count count">${group_info['count']}</div>
                                <div class="group-card__layers-types types">
                                    <svg class="text-withIcon__pic svgIcon-vector_layer"> <use
                                            xmlns:xlink="http://www.w3.org/1999/xlink"
                                            xlink:href="${request.static_url('nextgisweb:static/svg/svg-symbols.svg')}#vector_layer"></use>
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </div>
                </a>
            </div>
        %endfor
    </div>
</div>