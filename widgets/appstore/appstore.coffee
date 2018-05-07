class Dashing.Appstore extends Dashing.Widget
  ready: ->
    @onData(this)

  onData: (data) ->
    widget = $(@node)

    last_version = @get('last_version')
    all_versions = @get('all_versions')

    widget.find('.appstore-last-rating-value').html('<div>V' + last_version.version_number + '- Average Rating</div><span>' + last_version.average_rating + '/5' + '</span>')
    widget.find('.appstore-last-voters-count').html('<span>' + last_version.voters_count + '</span> Votes')

    widget.find('.appstore-all-rating-value').html('<div>All- Average Rating</div><span >' + all_versions.average_rating + '/5' + '</span>')
    widget.find('.appstore-all-voters-count').html('<span>' + all_versions.voters_count + '</span> Votes')

    widget.find('.appstore-last-review-first-author-rating').html('<div>Latest review</div><br/><span>' + last_version.reviews.first.author + ' - ' + last_version.reviews.first.version + ' - ' + last_version.reviews.first.rating + '/5' +  '</span>')
    widget.find('.appstore-last-review-first-title').html('<span>' + last_version.reviews.first.title + '</span>')
    widget.find('.appstore-last-review-first-description').html('<span>' + last_version.reviews.first.description + '</span>')

    widget.find('.appstore-last-review-second-author-rating').html('<br/><span>' + last_version.reviews.second.author + ' - ' + last_version.reviews.second.version + ' - ' + last_version.reviews.second.rating + '/5' +  '</span>')
    widget.find('.appstore-last-review-second-title').html('<span>' + last_version.reviews.second.title + '</span>')
    widget.find('.appstore-last-review-second-description').html('<span>' + last_version.reviews.second.description + '</span>')

    widget.find('.appstore-last-review-last-author-rating').html('<br/><span>' + last_version.reviews.last.author + ' - ' + last_version.reviews.last.version + ' - ' + last_version.reviews.last.rating + '/5' +  '</span>')
    widget.find('.appstore-last-review-last-title').html('<span>' + last_version.reviews.last.title + '</span>')
    widget.find('.appstore-last-review-last-description').html('<span>' + last_version.reviews.last.description + '</span>')

    widget.find('.appstore-all-footer-lastupdate').html('<span>Last update: ' + all_versions.last_update +  '</span>')
