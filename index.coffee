imgflo = require 'imgflo-url'


validate = (block, config, graph) ->
  throw new Error 'block not provided' unless block?

  {cover} = block
  throw new Error 'block must have a cover image' unless cover?
  throw new Error 'block cover image must have a src' unless cover.src?
  throw new Error 'block cover image must have a width' unless cover.width?
  throw new Error 'block cover image must have a height' unless cover.height?

  throw new Error 'imgflo config not provided' unless config?
  throw new Error 'imgflo graph name not provided' unless graph?


# rig (responsive image generator)
#
rig =

  # Item
  #
  # A dictionary representing a desired media query.
  #
  # @example
  #
  #   item =
  #     query: "(max-width: 768px)"
  #     selector: ".background"
  #     width: 768
  #
  # @property query [String] A CSS media query declaration, without the @media
  #   prefix or trailing {.
  # @property selector [String] One or more CSS selectors as declared in a
  #   ruleset, without the trailing {.
  # @property width [Number] The width of the desired image. Must not be
  #   provided with "height".
  # @property height [Number] The height of the desired image. Must not be
  #   provided with "width".


  # Generate media queries for a single image and graph combination.
  #
  # @example
  #
  #   $ = do require 'gom'
  #   rig = require 'rig-up'
  #
  #   config = solution.config.image_filters
  #
  #   params =
  #     'std-dev-x': 15
  #     'std-dev-y': 15
  #
  #   css = rig.generate
  #     block: block
  #     config: config
  #     graph: 'gaussianblur'
  #     params: params
  #     items: [{
  #       query: '(max-width: 503px)'
  #       selector: '.media, .background'
  #       width: 400
  #     }, {
  #       query: '(min-width: 504px) and (max-width: 1007px)'
  #       selector: '.media, .background'
  #       width: 800
  #     }, {
  #       query: '(min-width: 1008px)'
  #       selector: '.media, .background'
  #       height: 1200
  #     }]
  #
  #   $ 'style', { type: 'text/css' }, css
  #
  # @param options [Object] The media query generation options.
  # @option options block [Object] The content block.
  # @option options config [Object] An imgflo server config object.
  # @option options graph [String] The name of the imgflo graph.
  # @option options params [Object] The parameters to be passed to imgflo.
  # @option options items [Array<Item>] A list of items representing the
  #   desired media queries.
  # @return [String] The generated CSS media queries.
  #
  generate: (options) ->
    {block, config, graph, params, items} = options

    validate block, config, graph
    throw new Error 'query items not provided' unless items?

    {cover} = block
    mediaQueries = []

    for item in items
      {query, selector, width, height} = item
      throw new Error 'media query not provided' unless query?
      throw new Error 'selector not provided' unless selector?
      throw new Error 'width or height not provided' unless width? or height?
      throw new Error 'width or height must be provided, but not both' if width? and height?

      additionalParams =
        input: cover.src
        width: cover.width
        height: cover.height

      if width? and width < cover.width
        additionalParams.width = width
        additionalParams.height = width / (cover.width / cover.height)

      if height? and height < cover.height
        additionalParams.width = height * (cover.width / cover.height)
        additionalParams.height = height

      fullParams = {}
      fullParams[key] = value for key, value of params
      fullParams[key] = value for key, value of additionalParams

      url = imgflo config, graph, fullParams

      mediaQueries.push """
        @media #{query} {
          #{selector} {
            background-image: url('#{url}');
          }
        }
      """

    mediaQueries.join '\n\n'


  # Generate media queries for a single image, graph, and selector combination
  # at multiple breakpoints.
  #
  # @example
  #
  #   $ = do require 'gom'
  #   rig = require 'rig-up'
  #
  #   config = solution.config.image_filters
  #   breakpoints = [576, 864, 1152, 1440, 1728, 2016]
  #
  #   css = rig.breakpoints
  #     block: block
  #     config: config
  #     graph: 'passthrough'
  #     params: {}
  #     selector: '.background'
  #     breakpoints: breakpoints
  #
  #   $ 'style', { type: 'text/css' }, css
  #
  # @param options [Object] The media query generation options.
  # @option options block [Object] The content block.
  # @option options config [Object] An imgflo server config object.
  # @option options graph [String] The name of the imgflo graph.
  # @option options params [Object] The parameters to be passed to imgflo.
  # @option options selector [String] One or more CSS selectors as declared in a
  #   ruleset, without the trailing {.
  # @option options property [String] Valid values are 'width' or 'height'.
  # @option options items [Array<Number>] A list of numbers representing
  #   breakpoints for the desired media queries.
  # @return [String] The generated CSS media queries.
  #
  breakpoints: (options) ->
    {block, config, graph, params, property, selector, breakpoints} = options

    validate block, config, graph
    throw new Error 'property not provided' unless property?
    throw new Error 'invalid property provided' if property isnt 'width' and property isnt 'height'
    throw new Error 'selector not provided' unless selector?
    throw new Error 'breakpoints not provided' unless breakpoints?

    items = []
    sorted = breakpoints.sort (a, b) -> a - b

    for breakpoint, index in sorted
      isFirst = index is 0
      isLast = index is breakpoints.length - 1

      if isFirst
        item = { selector: selector }
        max = breakpoint - 1
        item.query = "(max-#{property}: #{max}px)"
        item[property] = max
        items.push item
      else
        item = { selector: selector }
        min = breakpoints[index - 1]
        max = breakpoint - 1
        item.query = "(min-#{property}: #{min}px) and (max-#{property}: #{max}px)"
        item[property] = max
        items.push item

      if isLast
        item = { selector: selector }
        min = breakpoint
        item.query = "(min-#{property}: #{min}px)"
        item[property] = min
        items.push item

    @generate
      block: block
      config: config
      graph: graph
      params: params
      items: items


  # Generate src and srcset attribute values for a single image and graph
  # combination at multiple breakpoints.
  #
  # @example
  #
  #   $ = do require 'gom'
  #   rig = require 'rig-up'
  #
  #   config = solution.config.image_filters
  #
  #   params =
  #     'std-dev-x': 15
  #     'std-dev-y': 15
  #
  #   breakpoints = [576, 864, 1152, 1440, 1728, 2016]
  #
  #   result = rig.srcset
  #     block: block
  #     config: config
  #     graph: 'gaussianblur'
  #     params: params
  #     breakpoints: breakpoints
  #
  #   $ 'img', { src: result.src, srcset: result.srcset, sizes: '100vw' }
  #
  # @param options [Object] The attribute value generation options.
  # @option options block [Object] The content block.
  # @option options config [Object] An imgflo server config object.
  # @option options graph [String] The name of the imgflo graph.
  # @option options params [Object] The parameters to be passed to imgflo.
  # @option options items [Array<Number>] A list of numbers representing
  #   breakpoints for the desired srcset attribute values.
  # @return [Object] A dictionary containing `src` and `srcset` keys.
  #
  srcset: (options) ->
    {block, config, graph, params, breakpoints} = options

    validate block, config, graph
    throw new Error 'breakpoints not provided' unless breakpoints?

    {cover} = block

    additionalParams =
      input: cover.src
      width: cover.width
      height: cover.height

    fullParams = {}
    fullParams[key] = value for key, value of params
    fullParams[key] = value for key, value of additionalParams

    result =
      src: imgflo config, graph, fullParams

    srcset = []
    sorted = breakpoints.sort (a, b) -> a - b

    for breakpoint in sorted
      additionalParams =
        input: cover.src
        width: breakpoint
        height: breakpoint / (cover.width / cover.height)

      fullParams = {}
      fullParams[key] = value for key, value of params
      fullParams[key] = value for key, value of additionalParams

      url = imgflo config, graph, fullParams

      srcset.push "#{url} #{breakpoint}w"

    result.srcset = srcset.join ", "
    result


module.exports = rig
