import Vue from 'vue/dist/vue.esm'

// register the grid component
Vue.component('demo-grid', {
    template: '#grid-template',
    mounted: function () {
        //hack to refresh grid from outside:)
        var vm = this;
        $("#refresh_grid_trigger").on('change', function () {
            vm.refreshGridData();
        });
    },
    props: {
        gridConfigData: Object,
    },
    data: function () {
        var sortOrders = {};
        this.gridConfigData.columns.forEach(function (key) {
            sortOrders[key] = 1
        });

        return {
            sortKey: '',
            sortOrders: sortOrders,
            filterKey: '',
            showDeleteModal: false,
            showEditModal: false,
            currentEntityId: null,
            gridData: null,
            formData: {},
            hideEdit: this.gridConfigData.hideEdit,
            hideNew: this.gridConfigData.hideNew
        }
    },
    computed: {
        filteredData: function () {
            var sortKey = this.sortKey;
            var filterKey = this.filterKey && this.filterKey.toLowerCase();
            var order = this.sortOrders[sortKey] || 1;
            var data = this.gridData;

            if (filterKey) {
                data = data.filter(function (row) {
                    return Object.keys(row).some(function (key) {
                        return String(row[key]).toLowerCase().indexOf(filterKey) > -1;
                    })
                })
            }

            if (sortKey) {
                data = data.slice().sort(function (a, b) {
                    a = a[sortKey];
                    b = b[sortKey];
                    return (a === b ? 0 : a > b ? 1 : -1) * order;
                })
            }

            return data;
        }
    },
    filters: {
        capitalize: function (str) {
            console.log(str);
            if (str !== null && str !== undefined) {
                return (str.charAt(0).toUpperCase() + str.slice(1)).replace('_', ' ');
            } else {
                return '';
            }
        }
    },
    created: function () {
        this.refreshGridData();
    },
    methods: {
        sortBy: function (key) {
            this.sortKey = key
            this.sortOrders[key] = this.sortOrders[key] * -1
        },
        showEdit: function (entity) {
            this.currentEntityId = entity['id'];
            //deep copy
            this.formData = JSON.parse(JSON.stringify(entity));
            this.showEditModal = true;
        },
        showNew: function () {
            this.currentEntityId = null;
            //deep copy
            this.formData = {};
            this.showEditModal = true;
        },
        showEntity: function () {

        },
        showDelete: function (entity) {
            this.currentEntityId = entity['id'];
            this.showDeleteModal = true;
        },
        refreshGridData: function () {
            $.getJSON(this.gridConfigData.getDataUrl, function (json) {
                this.gridData = json;
            }.bind(this));
        },
        doDeleteAction: function (id) {
            this.currentEntityId = id;
            this.showDeleteModal = false;
            $.ajax({
                url: this.gridConfigData.resourceUrl.replace('-1', this.currentEntityId),
                type: 'DELETE',
                success: function(result) {
                    this.refreshGridData();
                }.bind(this)
            });
        },
        doSaveAction: function (id) {
            this.currentEntityId = id;
            this.showEditModal = false;
            this.formData.user_id = this.gridConfigData.userId;
            var url;
            var type;

            //we are creating a new entity
            if (this.currentEntityId == null) {
                url = this.gridConfigData.resourceUrl.replace('/-1', '');
                type = 'POST';
            } else {
                url = this.gridConfigData.resourceUrl.replace('-1', this.currentEntityId);
                type = 'PUT';
            }

            $.ajax({
                url: url,
                type: type,
                data: this.formData,
                success: function(result) {
                    this.refreshGridData();
                }.bind(this)
            });
        }
    }
})

document.addEventListener('DOMContentLoaded', () => {
    var dataEl = document.getElementById("grid-data");
    var gridData = JSON.parse(dataEl.getAttribute("data"));

    var grid = new Vue({
        el: '#grid-container',
        data: {
            gridConfigData: gridData
        }
    })
})