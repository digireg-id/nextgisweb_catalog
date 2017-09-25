<%inherit file='nextgisweb:templates/base.mako' />

<%! from nextgisweb.pyramid.util import _ %>
<%! from platform import platform %>
<%! import sys %>

<%def name="head()">
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

<div id="groupContainer" class="catalog-inner">
    <header class="catalog-header">
        <h1><a href="${request.route_url('catalog.display', id=catalog.id)}">${title}</a></h1>
    </header>
    <div class="section content layers-rows">
        <div class="container">
            <h2 class="display-1">${catalog_item.display_name}</h2>
            %if catalog_item.description:
                <div>${catalog_item.description}</div>
            %endif
            <%include file="_layer_rows.mako"/>
        </div>
    </div>
    %if catalog.root_item and catalog.root_item.children:

    %else:
        <p>${tr(_("Empty catalog!"))}</p>
    %endif
</div>
