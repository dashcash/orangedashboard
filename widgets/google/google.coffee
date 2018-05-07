class Dashing.Google extends Dashing.Widget
  ready: ->
    @onData(this)
 
  onData: (data) ->
    widget = $(@node)
    last_version = @get('last_version')
    rating = last_version.average_rating
    rating_detail = last_version.average_rating_detail
    voters_count = last_version.voters_count
    widget.find('.google-rating-value').html( '<div>Average Rating</div><span id="google-rating-integer-value">' + rating + '</span>')
    if rating_detail then widget.find('.google-rating-detail-value').html( '<span id="google-rating-integer-value">' + rating_detail + '</span>')
    widget.find('.google-voters-count').html( '<span id="google-voters-count-value">' + voters_count + '</span> Reviews' )
   