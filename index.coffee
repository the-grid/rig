imgflo = require 'imgflo-url'
_ = require 'underscore'

# rig (responsive image generator)
#
# @example
#
#   $ = require 'gom'
#   rig = require 'rig'
#
#   config = solution.config.image_filters
#
#   params =
#     'std-dev-x': 15
#     'std-dev-y': 15
#
#   css = rig block, config, 'gaussianblur', params, [{
#     query: '(max-width: 503px)'
#     selector: '.media, .background'
#     width: 400
#   }, {
#     query: '(min-width: 504px) and (max-width: 1007px)'
#     selector: '.media, .background'
#     width: 800
#   }, {
#     query: '(min-width: 1008px)'
#     selector: '.media, .background'
#     height: 1200
#   }]
#
#   $ 'style', { type: 'text/css' }, css
#
# @param block [Object] The content block.
# @param config [Object] An imgflo server config object.
# @param graph [String] The name of the imgflo graph.
# @param params [Object] The parameters to be passed to imgflo.
# @param items [Array<Object>] A list of items representing the desired media
#   queries.
# @option items query [String] A CSS media query declaration, without the @media
#   prefix or trailing {.
# @option items selector [String] One or more CSS selectors as declared in a
#   ruleset, without the trailing {.
# @option items width [Number] The width of the desired image. Must not be
#   provided with "height".
# @option items height [Number] The height of the desired image. Must not be
#   provided with "width".
# @return [String] The generated CSS media queries.
#
rig = (block, config, graph, params, items) ->

  throw new Error 'block not provided' unless block?

  {cover} = block
  throw new Error 'block must have a cover image' unless cover?
  throw new Error 'block cover image must have a src' unless cover.src?
  throw new Error 'block cover image must have a width' unless cover.width?
  throw new Error 'block cover image must have a height' unless cover.height?

  throw new Error 'imgflo config not provided' unless config?
  throw new Error 'imgflo graph name not provided' unless graph?

  throw new Error 'query items not provided' unless items?

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

    fullParams = _.extend additionalParams, params
    url = imgflo config, graph, fullParams

    mediaQueries.push """
      @media #{query} {
        #{selector} {
          background-image: url('#{url}');
        }
      }
    """

  return mediaQueries.join '\n\n'


module.exports = rig
