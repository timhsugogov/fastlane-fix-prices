require_relative 'module'
require 'spaceship'

module Deliver
  # Set the app's pricing
  class UploadPriceTier
    def upload(options)
      UI.message("APP PRICE TIER")
      UI.message(options[:price_tier])
      options[:price_tier] = 0 unless options[:price_tier]

      price_tier = options[:price_tier].to_s

      app = Deliver.cache[:app]

      attributes = {}

      # Check App update method to understand how to use territory_ids.
      territory_ids = ["USA"] # nil won't update app's territory_ids, empty array would remove app from sale.
      

      # As of 2020-09-14:
      # Official App Store Connect does not have an endpoint to get app prices for an app
      # Need to get prices from the app's relationships
      # Prices from app's relationship does not have price tier so need to fetch app price with price tier relationship
      
      # app_prices = app.prices
      app_prices = [0]
      if app_prices&.first
        # app_price = Spaceship::ConnectAPI.get_app_price(app_price_id: 0, includes: "priceTier").first
        # old_price = app_price.price_tier.id
      else
        UI.message("App has no prices yet... Enabling all countries in App Store Connect")
        territory_ids = Spaceship::ConnectAPI::Territory.all.map(&:id)
        # attributes[:availableInNewTerritories] = true
      end

      # if price_tier == old_price
      #   UI.success("Price Tier unchanged (tier #{old_price})")
      #   return
      # end

      print("got to update code")
      begin
        update_res = app.update(attributes: attributes, app_price_tier_id: "0", territory_ids: territory_ids)
        print("UPDATE RES")
        print(update_res.inspect)
      rescue => e
        print("ERROR OCCURRED IN UPDATE")
        print(e)
      end
      # UI.success("Successfully updated the pricing from #{old_price} to #{price_tier}")
    end
  end
end
