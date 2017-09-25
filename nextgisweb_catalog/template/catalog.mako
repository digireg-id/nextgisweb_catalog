<%inherit file='nextgisweb:templates/base.mako' />

<%! from nextgisweb_catalog.util import _ %>
<%! from platform import platform %>
<%! import sys %>

<%def name="head()">
    <link href='https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Material+Icons' rel="stylesheet">
    <link href="https://unpkg.com/vuetify/dist/vuetify.min.css" rel="stylesheet">
    <link href="${request.route_url('amd_package', subpath='ngw-catalog/catalog/vuetify.min.css')}"
          rel="stylesheet" media="screen"/>
    <link href="${request.route_url('amd_package', subpath='ngw-catalog/catalog/catalog.css')}"
          rel="stylesheet" media="screen"/>
    <link href="${request.route_url('amd_package', subpath='ngw-catalog/catalog/icons/css/fontello.css')}"
          rel="stylesheet" media="screen"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons"
          rel="stylesheet">

    <script>
        require([
            "dojo/parser",
            "dojo/query",
            "dojo/dom-class",
            "dojo/_base/array",
            "dijit/TooltipDialog",
            "dijit/form/DropDownButton",
            "dijit/form/TextBox",
            "dijit/form/Button",
            "dojo/domReady!"
        ], function (parser, query, domClass, array) {
            parser.parse().then(function (instances) {
                var preLoadWidgets = query(".pre-load-widget");
                array.forEach(preLoadWidgets, function (div) {
                    domClass.remove(div, "pre-load-widget");
                });
            });
        });
    </script>
</%def>

<div class="catalog-main">
    <header class="catalog-header catalog-header--main section">
        <div class="container grid-list-xl">
            <h1>${title}</h1>
            %if catalog.description:
                <div class="catalog-header__description">${catalog.description | n}</div>
            %endif
        </div>
    </header>

    <section class="catalog-groups section">
        <%include file="_group_cards.mako"/>
    </section>
    <section class="catalog-layers catalog-recent section">
        <div class="container grid-list-xl">
            <h5 class="text-xs-center">${tr(_("New datasets"))}</h5>
            <%include file="_layer_rows.mako"/>
        </div>
    </section>
    %if catalog.root_item and catalog.root_item.children:

    %else:
        <p>${tr(_("Empty catalog!"))}</p>
    %endif
</div>
