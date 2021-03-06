// Generated by CoffeeScript 1.9.2
(function() {
  var imgflo, rig, validate;

  imgflo = require('imgflo-url');

  validate = function(block, config, graph) {
    var cover;
    if (block == null) {
      throw new Error('block not provided');
    }
    cover = block.cover;
    if (cover == null) {
      throw new Error('block must have a cover image');
    }
    if (cover.src == null) {
      throw new Error('block cover image must have a src');
    }
    if (cover.width == null) {
      throw new Error('block cover image must have a width');
    }
    if (cover.height == null) {
      throw new Error('block cover image must have a height');
    }
    if (config == null) {
      throw new Error('imgflo config not provided');
    }
    if (graph == null) {
      throw new Error('imgflo graph name not provided');
    }
  };

  rig = {
    generate: function(options) {
      var additionalParams, block, config, cover, fullParams, graph, height, i, item, items, key, len, mediaQueries, params, query, selector, url, value, width;
      block = options.block, config = options.config, graph = options.graph, params = options.params, items = options.items;
      validate(block, config, graph);
      if (items == null) {
        throw new Error('query items not provided');
      }
      cover = block.cover;
      mediaQueries = [];
      for (i = 0, len = items.length; i < len; i++) {
        item = items[i];
        query = item.query, selector = item.selector, width = item.width, height = item.height;
        if (query == null) {
          throw new Error('media query not provided');
        }
        if (selector == null) {
          throw new Error('selector not provided');
        }
        if (!((width != null) || (height != null))) {
          throw new Error('width or height not provided');
        }
        if ((width != null) && (height != null)) {
          throw new Error('width or height must be provided, but not both');
        }
        additionalParams = {
          input: cover.src,
          width: cover.width,
          height: cover.height
        };
        if ((width != null) && width < cover.width) {
          additionalParams.width = width;
          additionalParams.height = width / (cover.width / cover.height);
        }
        if ((height != null) && height < cover.height) {
          additionalParams.width = height * (cover.width / cover.height);
          additionalParams.height = height;
        }
        fullParams = {};
        for (key in params) {
          value = params[key];
          fullParams[key] = value;
        }
        for (key in additionalParams) {
          value = additionalParams[key];
          fullParams[key] = value;
        }
        url = imgflo(config, graph, fullParams);
        mediaQueries.push("@media " + query + " {\n  " + selector + " {\n    background-image: url('" + url + "');\n  }\n}");
      }
      return mediaQueries.join('\n\n');
    },
    breakpoints: function(options) {
      var block, breakpoint, breakpoints, config, graph, i, index, isFirst, isLast, item, items, len, max, min, params, property, selector, sorted;
      block = options.block, config = options.config, graph = options.graph, params = options.params, property = options.property, selector = options.selector, breakpoints = options.breakpoints;
      validate(block, config, graph);
      if (property == null) {
        throw new Error('property not provided');
      }
      if (property !== 'width' && property !== 'height') {
        throw new Error('invalid property provided');
      }
      if (selector == null) {
        throw new Error('selector not provided');
      }
      if (breakpoints == null) {
        throw new Error('breakpoints not provided');
      }
      items = [];
      sorted = breakpoints.sort(function(a, b) {
        return a - b;
      });
      for (index = i = 0, len = sorted.length; i < len; index = ++i) {
        breakpoint = sorted[index];
        isFirst = index === 0;
        isLast = index === breakpoints.length - 1;
        if (isFirst) {
          item = {
            selector: selector
          };
          max = breakpoint - 1;
          item.query = "(max-" + property + ": " + max + "px)";
          item[property] = max;
          items.push(item);
        } else {
          item = {
            selector: selector
          };
          min = breakpoints[index - 1];
          max = breakpoint - 1;
          item.query = "(min-" + property + ": " + min + "px) and (max-" + property + ": " + max + "px)";
          item[property] = max;
          items.push(item);
        }
        if (isLast) {
          item = {
            selector: selector
          };
          min = breakpoint;
          item.query = "(min-" + property + ": " + min + "px)";
          item[property] = min;
          items.push(item);
        }
      }
      return this.generate({
        block: block,
        config: config,
        graph: graph,
        params: params,
        items: items
      });
    },
    srcset: function(options) {
      var additionalParams, block, breakpoint, breakpoints, config, cover, filtered, fullParams, graph, i, key, len, params, result, sorted, src, srcset, url, value;
      block = options.block, config = options.config, graph = options.graph, params = options.params, breakpoints = options.breakpoints;
      validate(block, config, graph);
      if (breakpoints == null) {
        throw new Error('breakpoints not provided');
      }
      cover = block.cover;
      additionalParams = {
        input: cover.src,
        width: cover.width,
        height: cover.height
      };
      fullParams = {};
      for (key in params) {
        value = params[key];
        fullParams[key] = value;
      }
      for (key in additionalParams) {
        value = additionalParams[key];
        fullParams[key] = value;
      }
      src = imgflo(config, graph, fullParams);
      result = {
        src: src
      };
      srcset = [];
      filtered = (function() {
        var i, len, results;
        results = [];
        for (i = 0, len = breakpoints.length; i < len; i++) {
          breakpoint = breakpoints[i];
          if (breakpoint < cover.width) {
            results.push(breakpoint);
          }
        }
        return results;
      })();
      sorted = filtered.sort(function(a, b) {
        return a - b;
      });
      for (i = 0, len = sorted.length; i < len; i++) {
        breakpoint = sorted[i];
        additionalParams = {
          input: cover.src,
          width: breakpoint,
          height: breakpoint / (cover.width / cover.height)
        };
        fullParams = {};
        for (key in params) {
          value = params[key];
          fullParams[key] = value;
        }
        for (key in additionalParams) {
          value = additionalParams[key];
          fullParams[key] = value;
        }
        url = imgflo(config, graph, fullParams);
        srcset.push(url + " " + breakpoint + "w");
      }
      if (breakpoints.length > filtered.length) {
        srcset.push(src + " " + cover.width + "w");
      }
      result.srcset = srcset.join(", ");
      return result;
    }
  };

  module.exports = rig;

}).call(this);
