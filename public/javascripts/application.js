function refresh_feed(link) {
  new Ajax.Request('/feeds/' + link.getAttribute('id').split("_")[1] + '/refresh', { method: 'post' })
  spin_and_wait(link)
}

function refresh_all() {
  new Ajax.Request('/feeds/refresh', { method: 'post' })
  $$('.feed .refresh a').each(function(link) {
    spin_and_wait(link)
  })
}

function spin_and_wait(link) {
  link.addClassName('refreshing')
}

function update_feed(id) {
  new Ajax.Updater('feed_' + id, '/feeds/' + id, { method: 'get' });
}
