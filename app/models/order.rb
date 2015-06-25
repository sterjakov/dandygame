# -*- encoding : utf-8 -*-
class Order < ActiveRecord::Base

  attr_accessor  :price, :cost

  belongs_to :user

  PRICE = [

      {
          id: 1,
          number: 6,
          cost: 200
      },

      {
          id: 2,
          number: 12,
          cost: 300
      },

      {
          id: 3,
          number: 48,
          cost: 1000
      },

      {
          id: 4,
          number: 96,
          cost: 1800
      }

  ]

  validates :item_id,   inclusion: { in: Order::PRICE.map{ |price| price[:id] },  message: 'не выбран или его не существует!'  }


  def self.human_attribute_name(*attr)
    I18n.t('activerecord.attributes.' + attr[0].to_s)
  end
end
