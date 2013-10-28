CollectionView = require "views/base/collection-view"
NewsItemView = require "./news-item-view"

module.exports = class NewtabIndexView extends CollectionView
  autoRender: yes
  className: "b-news-tile b-news-tile_loading"
  itemView: NewsItemView
  template: require "./templates/index"

  initialize: ->
    $(window).on "scroll.#{@cid}", @onScroll.bind @

    # don't fetch 'till the request will be finished
    @noFetch = yes

    # for offset
    @page = 0

    super

  onScroll: ->
    # @todo: each batch of news should be in the separate container
    if not @noFetch and document.height - $(document).scrollTop() - document.body.clientHeight <= 0
      @noFetch = yes
      @collection.fetch
        remove: no
        data:
          offset: ++@page * 30

  onSync: ->
    @noFetch = no
    @$el.removeClass "b-news-tile_loading"

  listen:
    "sync collection": "onSync"