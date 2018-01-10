# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

Rails.application.config.assets.precompile += %w( Base.js Component.js
  Config.js GridMenu.js Menubar.js PageAside.js Plugin.js Sidebar.js Site.js
  State.js asscrollable.js colors.js menu.js slidepanel.js switchery.js
  tabs.js bootstrap-datepicker.js bootstrap-select.js matchheight.js
  application_new.css application_new.js custom_layout.js jquery.min.js
  bootstrap.min.js jquery-3.2.1.slim.min popper.js chartist.min.css
  chartist-plugin-tooltip.css chartist.min chartist-plugin-tooltip.min )



# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
