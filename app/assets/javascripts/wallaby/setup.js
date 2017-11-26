jQuery(document).off('turbolinks:load.wallaby').on('turbolinks:load.wallaby', function () {
  'use strict';

  jQuery('[data-toggle="tooltip"]').tooltip({ html: true, container:'body' })
  jQuery('#imodal').on('show.bs.modal', function (event) {
    var $button = jQuery(event.relatedTarget),
        $this = jQuery(this);
    $this.find('.modal-title').html($button.siblings('.modaler__title').html());
    $this.find('.modal-body').html($button.siblings('.modaler__body').html());
  })

  jQuery('.index').each(function() {
    jQuery('.query', this).each(function () {
      var $this = jQuery(this);
      jQuery('input:visible', this).on('focus.modifier', function () {
        $this.addClass('query--focus');
      }).on('blur', function () {
        $this.removeClass('query--focus');
      })
    })

    jQuery('.resources').each(function () {
      var $this = jQuery(this);

      // let's clone the actions, just for styling
      jQuery('.resources__data', this).each(function () {
        var $actions_table = jQuery('<table></table>').addClass('resources__actions'),
            $thead = jQuery('<thead><tr><th>&nbsp;</th></tr></thead>'),
            $tbody = jQuery('<tbody></tbody>'),
            $tr = jQuery('<tr></tr>');

        jQuery('.resource__actions', this).each(function () {
          $tbody.append($tr.clone().append(jQuery(this).clone()));
        })

        $actions_table.append($thead, $tbody);
        jQuery('> section', $this).append($actions_table);
      })

      // to show double arrows
      jQuery('.resources__container').on('scroll', function () {
        var $container = jQuery(this),
            $th = jQuery('.resources__actions thead th', $this),
            $data_table = jQuery('.resources__data', $this);

        $th.toggleClass('resources--backward', $container.scrollLeft() > 0);
        $th.toggleClass('resources--forward', $container.scrollLeft() + $container.width() < $data_table.width());
      }).trigger('scroll');
    })
  })

  if (CodeMirror) {
    CodeMirror.defaults.theme = "mdn-like";
    CodeMirror.defaults.lineNumbers = true;
  }
})
