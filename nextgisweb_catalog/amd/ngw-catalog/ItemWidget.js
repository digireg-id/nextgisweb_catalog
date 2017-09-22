/* globals define, console */
define([
    "dojo/_base/declare",
    "dojo/_base/array",
    "dojo/_base/lang",
    "dojo/dom-style",
    "dijit/layout/ContentPane",
    "dijit/_TemplatedMixin",
    "dijit/_WidgetsInTemplateMixin",
    "dojo/data/ItemFileWriteStore",
    "dijit/tree/TreeStoreModel",
    "dijit/Tree",
    "dijit/tree/dndSource",
    "dijit/registry",
    "ngw-resource/serialize",
    "ngw-resource/ResourcePicker",
    "ngw-pyramid/i18n!catalog",
    "ngw-pyramid/hbs-i18n",
    // resource
    "dojo/text!./template/ItemWidget.hbs",
    // template
    "dijit/layout/TabContainer",
    "dojox/layout/TableContainer",
    "dijit/layout/BorderContainer",
    "dijit/layout/StackContainer",
    "dijit/layout/ContentPane",
    "dijit/Dialog",
    "dijit/Toolbar",
    "ngw-pyramid/form/DisplayNameTextBox",
    "ngw-pyramid/form/RTETextBox",
    'ngw-resource/ResourceBox',
    "dijit/form/TextBox",
    "dijit/form/CheckBox"
], function (declare,
             array,
             lang,
             domStyle,
             ContentPane,
             _TemplatedMixin,
             _WidgetsInTemplateMixin,
             ItemFileWriteStore,
             TreeStoreModel,
             Tree,
             dndSource,
             registry,
             serialize,
             ResourcePicker,
             i18n,
             hbsI18n,
             template) {
    return declare([ContentPane, serialize.Mixin, _TemplatedMixin, _WidgetsInTemplateMixin], {
        title: i18n.gettext("Layers"),
        templateString: hbsI18n(template, i18n),

        constructor: function () {
            this.itemStore = new ItemFileWriteStore({
                data: {
                    items: [{item_type: "root"}]
                }
            });

            this.itemModel = new TreeStoreModel({
                store: this.itemStore,
                query: {}
            });

            var widget = this;

            this.widgetTree = new Tree({
                model: this.itemModel,
                showRoot: false,
                getLabel: function (item) {
                    return item.display_name;
                },
                getIconClass: function (item, opened) {
                    return item.item_type == "group" ? (opened ? "dijitFolderOpened" : "dijitFolderClosed") : "dijitLeaf";
                },
                persist: false,
                dndController: dndSource,
                checkItemAcceptance: function (node, source, position) {
                    var item = registry.getEnclosingWidget(node).item,
                        item_type = widget.itemStore.getValue(item, "item_type");
                    // Блокируем возможность перетащить элемент внутрь слоя,
                    // перенос внутрь допустим только для группы
                    return item_type === "group" || (item_type === "layer" && position !== "over");
                },
                betweenThreshold: 5
            });
        },

        postCreate: function () {
            this.inherited(arguments);

            // Создать дерево без model не получается, поэтому создаем его вручную
            this.widgetTree.placeAt(this.containerTree).startup();

            var widget = this;

            // Добавление новой группы
            this.btnAddGroup.on("click", function () {
                widget.itemStore.newItem(
                    {
                        display_name: i18n.gettext("Add group"),
                        description: "",
                        item_type: "group"
                    }, {
                        parent: widget.getAddParent(),
                        attribute: "children"
                    }
                );
            });

            // Добавление нового слоя
            this.btnAddLayer.on("click", lang.hitch(this, function () {
                this.layerPicker.pick().then(lang.hitch(this, function (itm) {
                    this.itemStore.newItem({
                            "item_type": "layer",
                            "display_name": itm.display_name,
                            "description": "",
                            "layer_enabled": true,
                            "layer_wms_id": null,
                            "layer_wfs_id": null,
                            "layer_webmap_id": null,
                            "layer_resource_id": itm.id
                        }, {
                            parent: widget.getAddParent(),
                            attribute: "children"
                        }
                    );
                }));
            }));

            // Удаление слоя или группы
            this.btnDeleteItem.on("click", function () {
                widget.itemStore.deleteItem(widget.widgetTree.selectedItem);
                widget.treeLayoutContainer.removeChild(widget.itemPane);
                widget.btnDeleteItem.set("disabled", true);
            });

            this.widgetTree.watch("selectedItem", function (attr, oldValue, newValue) {
                if (newValue) {
                    // При изменении выделенного элемента перенесем значения в виджеты
                    // и покажем нужную панель: для слоев одну, для групп другую.
                    if (newValue.item_type == "group") {
                        widget.widgetItemDisplayNameGroup.set("value", widget.getItemValue("display_name"));
                        widget.widgetItemDescriptionGroup.set("value", widget.getItemValue("description"));
                        widget.widgetProperties.selectChild(widget.paneGroup);
                    } else if (newValue.item_type == "layer") {
                        widget.widgetItemDisplayNameLayer.set("value", widget.getItemValue("display_name"));
                        widget.widgetItemDescriptionLayer.set("value", widget.getItemValue("description"));
                        widget.wdgtItemLayerEnabled.set("checked", widget.getItemValue("layer_enabled"));

                        var layer_webmap_id = widget.getItemValue("layer_webmap_id");
                        widget.widgetWebMapLayer.set("value", layer_webmap_id ? {id: layer_webmap_id} : null);

                        var layer_wms_id = widget.getItemValue("layer_wms_id");
                        widget.widgetWMSLayer.set("value", layer_wms_id ? {id: layer_wms_id} : null);

                        var layer_wfs_id = widget.getItemValue("layer_wfs_id");
                        widget.widgetWFSLayer.set("value", layer_wfs_id ? {id: layer_wfs_id} : null);

                        widget.widgetProperties.selectChild(widget.paneLayer);
                    }

                    // Изначально боковая панель со свойствами текущего элемента
                    // спрятана. Поскольку элемент уже выбран - ее нужно показать.
                    if (!oldValue) {
                        domStyle.set(widget.itemPane.domNode, "display", "block");
                        widget.treeLayoutContainer.addChild(widget.itemPane);
                    }

                    // Активируем кнопку удаления слоя или группы
                    widget.btnDeleteItem.set("disabled", false);
                }
            });

            // При изменении значений переносим их в модель
            this.widgetItemDisplayNameGroup.watch("value", function (attr, oldValue, newValue) {
                widget.setItemValue("display_name", newValue);
            });

            this.widgetItemDisplayNameLayer.watch("value", function (attr, oldValue, newValue) {
                widget.setItemValue("display_name", newValue);
            });

            this.widgetItemDescriptionGroup.watch("value", function (attr, oldValue, newValue) {
                widget.setItemValue("description", newValue);
            });

            this.widgetItemDescriptionLayer.watch("value", function (attr, oldValue, newValue) {
                widget.setItemValue("description", newValue);
            });

            this.wdgtItemLayerEnabled.watch("checked", function (attr, oldValue, newValue) {
                widget.setItemValue("layer_enabled", newValue);
            });

            this.widgetWebMapLayer.on("picked", function (event) {
                var webmap = event.resource;
                widget.setItemValue("layer_webmap_id", webmap.id);
            });

            this.widgetWMSLayer.on("picked", function (event) {
                var wmsLayer = event.resource;
                widget.setItemValue("layer_wms_id", wmsLayer.id);
            });

            this.widgetWFSLayer.on("picked", function (event) {
                var wfsLayer = event.resource;
                widget.setItemValue("layer_wfs_id", wfsLayer.id);
            });
        },

        startup: function () {
            this.inherited(arguments);
        },

        getAddParent: function () {
            if (this.getItemValue("item_type") == "group") {
                return this.widgetTree.selectedItem;
            } else {
                return this.itemModel.root;
            }
        },

        // установить значение аттрибута текущего элемента
        setItemValue: function (attr, value) {
            this.itemStore.setValue(this.widgetTree.selectedItem, attr, value);
        },

        // значение аттрибута текущего элемента
        getItemValue: function (attr) {
            if (this.widgetTree.selectedItem) {
                return this.itemStore.getValue(this.widgetTree.selectedItem, attr);
            }
        },

        serializeInMixin: function (data) {
            if (data.catalog === undefined) {
                data.catalog = {};
            }
            var store = this.itemStore;

            // Простого способа сделать дамп данных из itemStore
            // почему-то нет, поэтому обходим рекурсивно.
            function traverse(itm) {
                return {
                    item_type: store.getValue(itm, "item_type"),
                    display_name: store.getValue(itm, "display_name"),
                    description: store.getValue(itm, "description"),
                    layer_enabled: store.getValue(itm, "layer_enabled"),
                    layer_wms_id: store.getValue(itm, "layer_wms_id"),
                    layer_wfs_id: store.getValue(itm, "layer_wfs_id"),
                    layer_webmap_id: store.getValue(itm, "layer_webmap_id"),
                    layer_resource_id: store.getValue(itm, "layer_resource_id"),
                    children: array.map(store.getValues(itm, "children"), function (i) {
                        return traverse(i);
                    })
                };
            }

            data.catalog.root_item = traverse(this.itemModel.root);
        },

        deserializeInMixin: function (data) {
            var value = data.catalog.root_item;
            if (value === undefined) {
                return;
            }

            var widget = this;

            function traverse(item, parent) {
                array.forEach(item.children, function (i) {
                    var element = {};
                    for (var key in i) {
                        if (key !== "children") {
                            element[key] = i[key];
                        }
                    }
                    var new_item = widget.itemStore.newItem(element, {parent: parent, attribute: "children"});
                    if (i.children) {
                        traverse(i, new_item);
                    }
                }, widget);
            }

            traverse(value, this.itemModel.root);
        }
    });
});
