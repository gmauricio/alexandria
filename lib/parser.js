'use strict';

const cheerio = require('cheerio');

module.exports = (host, html) => {
    const $ = cheerio.load(html);
    return {
        getResults: () => {
            const results = $('#listing').find('tr');
            return results.map((i, el) => {
                const tr = $(el);
                return {
                    host,
                    title: $('.first-line', tr).text(),
                    description: $('.second-line', tr).text(),
                    urls: tr.find('a').map((i, el) => $(el).attr('href')).get(),
                    thumbUrl: tr.find('img').map((i, el) => $(el).attr('src')).get()[0],
                }
            }).get();
        }
    }
}
