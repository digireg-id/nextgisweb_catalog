<%inherit file='nextgisweb:templates/base.mako' />

<%! from nextgisweb.pyramid.util import _ %>
<%! from platform import platform %>
<%! import sys %>

<%def name="head()">
    <link href="${request.route_url('amd_package', subpath='ngw-catalog/catalog/catalog.css')}"
          rel="stylesheet" media="screen"/>

    <script>
        require([
            "dojo/ready"
        ], function (ready) {
            ready(function () {

            });
        });
    </script>
</%def>

<div class="content pure-g">
    <div class="content__inner pure-u-1 expand">
        <div id="title" class="title">
            <div class="content__container container">
                <h1>${title}</h1>
                %if catalog.description:
                    <span class="catalog-description">${catalog.description | n}</span>
                %endif
            </div>
        </div>

        <div class="content-wrapper">
            <div class="pure-u-1 expand">
                <div class="content__container container expand">
                        <%include file="_group_cards.mako"/>
                </div>
            </div>
        </div>
        <div class="content-wrapper layers-rows">
            <div class="pure-u-1 expand">
                <div class="content__container container expand">
                        <%include file="_layer_rows.mako"/>
                </div>
            </div>
        </div>
        %if catalog.root_item and catalog.root_item.children:

        %else:
            <p>${tr(_("Empty catalog!"))}</p>
        %endif
    </div>
</div>
