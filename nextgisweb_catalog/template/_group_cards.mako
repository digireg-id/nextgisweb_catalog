<div id="catalogGroups">
    %for group_info in ui_catalog_items['groups']:
        <div class="group-card">
            <div class="group-title">
                <a href="${request.route_url('catalog.group', id=catalog.id, group_id=group_info['id'])}"
                   title="${group_info['title']}">
                    ${group_info['title']}
                </a>
            </div>
            <div class="group-description">${group_info['description'] | n}</div>
            <div class="count_info">
                <div class="count">${group_info['count']}</div>
                <div class="types">
                    <span class="text-withIcon">
                        <span class="text-withIcon__icon">
                            <svg class="text-withIcon__pic svgIcon-vector_layer"> <use
                                    xmlns:xlink="http://www.w3.org/1999/xlink"
                                    xlink:href="${request.static_url('nextgisweb:static/svg/svg-symbols.svg')}#vector_layer"></use>
                            </svg>
                        </span>
                    </span>
                </div>
            </div>
        </div>
    %endfor
</div>