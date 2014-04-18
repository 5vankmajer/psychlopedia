# encoding: utf-8

class Experience < ActiveRecord::Base
  extend FriendlyId

  has_many :cocktails, dependent: :destroy
  accepts_nested_attributes_for :cocktails, reject_if: lambda { |cocktail| cocktail[:substance].blank? || cocktail[:dosage].blank? }

  friendly_id :title, use: :slugged

  validates :body, uniqueness: true, presence: true

  before_save :defaults

  default_scope {order('created_at DESC')}

  serialize :hearts, Hash

  # will_paginate per-page limit
  def self.per_page
    10
  end

  def self.random
    return Experience.none unless Experience.exists?
    Experience.find Experience.ids.sample
  end

  # XXX: a poor's man (and a poor's mind) search engine.
  def self.search(query)
    @results = []
    ["%#{query}", "%#{query}%", "#{query}%"].each do |query|
      ["title", "pseudonym"].each do |field|
        candidates = Experience.where("LOWER(#{field}) LIKE ?", query)
        @results << candidates unless candidates.empty?
      end
    end
    @results.flatten.uniq
  end

  def defaults
    self.pseudonym ||= 'anónimo'
    self.title ||= 'sin título'
  end

  def human_readable_rating
    if self.hearts.empty?
      ('&#9734;' * 5).html_safe
    else
      black_stars = self.hearts.max_by { |stars, quantity| quantity }.first.to_i
      (('&#9733;' * black_stars) + ('&#9734;' * (5 - black_stars))).html_safe
    end
  end
end
