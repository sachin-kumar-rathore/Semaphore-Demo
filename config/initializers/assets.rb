# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

Rails.application.config.assets.precompile += %w( breakpoints.js babel-external-helpers.js Base.js 
  Component.js Config.js GridMenu.js Menubar.js PageAside.js Plugin.js Sidebar.js Site.js State.js 
  animsition.js asscrollable.js bootstrap.js chartist-plugin-tooltip.min.js 
  chartist.min.js colors.js intro.js jquery-asHoverScroll.js jquery-asScrollable.js jquery-asScrollbar.js 
  jquery-jvectormap-world-mill-en.js jquery-jvectormap.min.js jquery.js jquery-slidePanel.js plugins/bootstrap-select.js
  jquery.matchHeight-min.js jquery.mousewheel.js jquery.peity.min.js jvectormap.js matchheight.js menu.js peity.js
  screenfull.js slidepanel.js switchery.js switchery.min.js tether.js tour.js v1.js waves.js jquery.tokeninput.js
  tabs.js bootstrap-datepicker.js bootstrap-select.js 
  plugins/bootstrap-datepicker.js )



# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
