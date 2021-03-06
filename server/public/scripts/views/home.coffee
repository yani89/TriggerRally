define [
  'cs!views/view'
  'jade!templates/home'
], (
  View
  template
) ->
  class HomeView extends View
    className: 'overlay'
    template: template
    constructor: (@app, @client) -> super()

    initialize: ->
      @listenTo @app.root, 'change:user', => @render()

    viewModel: ->
      loggedIn: @app.root.user?
      credits: @app.root.user?.credits
      # xpTwitterPromo: @app.root.xp.dimension2

    afterRender: ->
      do updateDriveButton = =>
        trackId = @app.root.track?.id
        @$('.drivebutton').attr 'href', "/track/#{trackId}/drive" if trackId
      @listenTo @app.root, 'change:track.', updateDriveButton

      $userCredits = @$('.ca-credit.usercredits')
      @listenTo @app.root, 'change:user.credits', =>
        # TODO: Animate credit gains.
        $userCredits.text @app.root.user?.credits

      do updatePromo = =>
        products = @app.root.user?.products ? []
        packa = 'packa' in products
        @$('.ignition-promo').toggleClass 'hidden', packa or 'ignition' in products
        @$('.mayhem-promo').toggleClass 'hidden', packa or 'mayhem' in products

      @listenTo @app.root, 'change:user.products', updatePromo

      @$('.purchasebutton a').on 'click', (event) =>
        @app.showCreditPurchaseDialog()
        false

      return
