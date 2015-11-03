{expect} = require 'chai'
rig = require '../lib/rig'
imgflo = require 'imgflo-url'


validateBlock = (fn) ->

  describe 'without a block', ->

    block = null

    it 'should throw an error', ->
      exercise = -> fn block
      expect(exercise).to.throw Error, 'block not provided'


  context 'with a block', ->

    describe 'without a cover image', ->

      block =
        type: 'media'

      it 'should throw an error', ->
        exercise = -> fn block
        expect(exercise).to.throw Error, 'block must have a cover image'


    context 'with a cover image', ->

      describe 'without a src', ->

        block =
          type: 'media'
          cover:
            width: 1600
            height: 900

        it 'should throw an error', ->
          exercise = -> fn block
          expect(exercise).to.throw Error, 'block cover image must have a src'


      describe 'without a width', ->

        block =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            height: 900

        it 'should throw an error', ->
          exercise = -> fn block
          expect(exercise).to.throw Error, 'block cover image must have a width'


      describe 'without a height', ->

        it 'should throw an error', ->
          block =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600

          exercise = -> fn block
          expect(exercise).to.throw Error, 'block cover image must have a height'



validateConfig = (fn) ->

  describe 'without an imgflo config object', ->

    config = null

    it 'should throw an error', ->
      exercise = -> fn config
      expect(exercise).to.throw Error, 'imgflo config not provided'



validateGraph = (fn) ->

  describe 'without a graph name', ->

    graph = null

    it 'should throw an error', ->
      exercise = -> fn graph
      expect(exercise).to.throw Error, 'imgflo graph name not provided'


validate = (block, config, graph, fn) ->

  validateBlock do (config, graph) ->
    (block) -> fn block, config, graph

  validateConfig do (block, graph) ->
    (config) -> fn block, config, graph

  validateGraph do (block, config) ->
    (graph) -> fn block, config, graph



describe 'Responsive image generator', ->

  fixtures =

    block:
      type: 'media'
      cover:
        src: 'https://a.com/b.png'
        width: 1600
        height: 900

    config:
      server: 'https://imgflo.herokuapp.com/'
      key: 'key'
      secret: 'secret'

    graph: "passthrough"



  describe "generate", ->

    validate fixtures.block, fixtures.config, fixtures.graph, (block, config, graph) ->
      rig.generate
        block: block
        config: config
        graph: graph
        params: {}
        items: [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 800
        }]


    describe 'without any query items', ->

      items = null

      it 'should throw an error', ->
        exercise = ->
          {block, config, graph} = fixtures

          rig.generate
            block: block
            config: config
            graph: graph
            params: {}
            items: items

        expect(exercise).to.throw Error, 'query items not provided'


    context 'with a query item', ->

      describe 'without a media query', ->

        items = [{
          selector: '.media, .background'
          width: 800
        }]

        it 'should throw an error', ->
          exercise = ->
            {block, config, graph} = fixtures

            rig.generate
              block: block
              config: config
              graph: graph
              params: {}
              items: items

          expect(exercise).to.throw Error, 'media query not provided'


      describe 'without a selector', ->

        items = [{
          query: '(max-width: 503px)'
          width: 800
        }]

        it 'should throw an error', ->
          exercise = ->
            {block, config, graph} = fixtures

            rig.generate
              block: block
              config: config
              graph: graph
              params: {}
              items: items

          expect(exercise).to.throw Error, 'selector not provided'


      describe 'without a width or height', ->

        items = [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
        }]

        it 'should throw an error', ->
          exercise = ->
            {block, config, graph} = fixtures

            rig.generate
              block: block
              config: config
              graph: graph
              params: {}
              items: items

          expect(exercise).to.throw Error, 'width or height not provided'


      describe 'specifying both width and height', ->

        items = [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 800
          height: 450
        }]

        it 'should throw an error', ->
          exercise = ->
            {block, config, graph} = fixtures

            rig.generate
              block: block
              config: config
              graph: graph
              params: {}
              items: items

          expect(exercise).to.throw Error, 'width or height must be provided, but not both'


      describe 'with a width larger than the original', ->

        items = [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 1920
        }]

        it 'should use the original width', ->
          {block, config, graph} = fixtures

          css = rig.generate
            block: block
            config: config
            graph: graph
            params: {}
            items: items

          url = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 1600
            height: 900

          expect(css).to.equal """
            @media (max-width: 503px) {
              .media, .background {
                background-image: url('#{url}');
              }
            }
          """


      describe 'with a height larger than the original', ->

        items = [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          height: 1200
        }]

        it 'should use the original height', ->
          {block, config, graph} = fixtures

          css = rig.generate
            block: block
            config: config
            graph: graph
            params: {}
            items: items

          url = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 1600
            height: 900

          expect(css).to.equal """
            @media (max-width: 503px) {
              .media, .background {
                background-image: url('#{url}');
              }
            }
          """


    context 'with a valid block and query items', ->

      describe 'providing widths', ->

        items = [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 400
        }, {
          query: '(min-width: 504px) and (max-width: 1007px)'
          selector: '.media, .background'
          width: 800
        }]

        it 'should generate media queries', ->
          {block, config, graph} = fixtures

          css = rig.generate
            block: block
            config: config
            graph: graph
            params: {}
            items: items

          firstUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 400
            height: 225

          secondUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 800
            height: 450

          expect(css).to.equal """
            @media (max-width: 503px) {
              .media, .background {
                background-image: url('#{firstUrl}');
              }
            }

            @media (min-width: 504px) and (max-width: 1007px) {
              .media, .background {
                background-image: url('#{secondUrl}');
              }
            }
          """


      describe 'providing heights', ->

        items = [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          height: 225
        }, {
          query: '(min-width: 504px) and (max-width: 1007px)'
          selector: '.media, .background'
          height: 450
        }]

        it 'should generate media queries', ->
          {block, config, graph} = fixtures

          css = rig.generate
            block: block
            config: config
            graph: graph
            params: {}
            items: items

          firstUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 400
            height: 225

          secondUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 800
            height: 450

          expect(css).to.equal """
            @media (max-width: 503px) {
              .media, .background {
                background-image: url('#{firstUrl}');
              }
            }

            @media (min-width: 504px) and (max-width: 1007px) {
              .media, .background {
                background-image: url('#{secondUrl}');
              }
            }
          """


      describe 'providing a mixture of widths and heights', ->

        items = [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 400
        }, {
          query: '(min-width: 504px) and (max-width: 1007px)'
          selector: '.media, .background'
          height: 450
        }]

        it 'should generate media queries', ->
          {block, config, graph} = fixtures

          css = rig.generate
            block: block
            config: config
            graph: graph
            params: {}
            items: items

          firstUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 400
            height: 225

          secondUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 800
            height: 450

          expect(css).to.equal """
            @media (max-width: 503px) {
              .media, .background {
                background-image: url('#{firstUrl}');
              }
            }

            @media (min-width: 504px) and (max-width: 1007px) {
              .media, .background {
                background-image: url('#{secondUrl}');
              }
            }
          """


        describe 'using a more complex imgflo graph', ->

          graph = 'gaussianblur'

          params =
            'std-dev-x': 15
            'std-dev-y': 15

          it 'should generate media queries', ->
            {block, config} = fixtures

            css = rig.generate
              block: block,
              config: config,
              graph: graph,
              params: params,
              items: [{
                query: '(max-width: 503px)'
                selector: '.media, .background'
                width: 400
              }, {
                query: '(min-width: 504px) and (max-width: 1007px)'
                selector: '.media, .background'
                height: 450
              }]

            firstUrl = imgflo config, 'gaussianblur',
              'std-dev-x': 15
              'std-dev-y': 15
              input: 'https://a.com/b.png'
              width: 400
              height: 225

            secondUrl = imgflo config, 'gaussianblur',
              'std-dev-x': 15
              'std-dev-y': 15
              input: 'https://a.com/b.png'
              width: 800
              height: 450

            expect(css).to.equal """
              @media (max-width: 503px) {
                .media, .background {
                  background-image: url('#{firstUrl}');
                }
              }

              @media (min-width: 504px) and (max-width: 1007px) {
                .media, .background {
                  background-image: url('#{secondUrl}');
                }
              }
            """


  describe 'breakpoints', ->

    validate fixtures.block, fixtures.config, fixtures.graph, (block, config, graph) ->
      rig.breakpoints
        block: block
        config: config
        graph: graph
        params: {}
        property: 'width'
        selector: '.background'
        breakpoints: [800, 1200]


    describe 'property option', ->

      context 'not provided', ->

        property = null

        it 'should throw an error', ->
          exercise = ->
            {block, config, graph} = fixtures

            rig.breakpoints
              block: block
              config: config
              graph: graph
              params: {}
              property: property
              selector: '.background'
              breakpoints: [800, 1200]

          expect(exercise).to.throw Error, 'property not provided'


      context 'invalid', ->

        property = 'widt'

        it 'should throw an error', ->
          exercise = ->
            {block, config, graph} = fixtures

            rig.breakpoints
              block: block
              config: config
              graph: graph
              params: {}
              property: property
              selector: '.background'
              breakpoints: [800, 1200]

          expect(exercise).to.throw Error, 'invalid property provided'


      context 'width', ->

        property = 'width'

        it 'should generate media queries', ->
          {block, config, graph} = fixtures

          css = rig.breakpoints
            block: block
            config: config
            graph: graph
            params: {}
            property: property
            selector: '.background'
            breakpoints: [800, 1200]

          firstUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 799
            height: (799 / 1600) * 900

          secondUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 1199
            height: (1199 / 1600) * 900

          thirdUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 1200
            height: (1200 / 1600) * 900

          expect(css).to.equal """
            @media (max-width: 799px) {
              .background {
                background-image: url('#{firstUrl}');
              }
            }

            @media (min-width: 800px) and (max-width: 1199px) {
              .background {
                background-image: url('#{secondUrl}');
              }
            }

            @media (min-width: 1200px) {
              .background {
                background-image: url('#{thirdUrl}');
              }
            }
          """


      context 'height', ->

        property = 'height'

        it 'should generate media queries', ->
          {block, config, graph} = fixtures

          css = rig.breakpoints
            block: block
            config: config
            graph: graph
            params: {}
            property: property
            selector: '.background'
            breakpoints: [300, 600]

          firstUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: (299 / 900) * 1600
            height: 299

          secondUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: (599 / 900) * 1600
            height: 599

          thirdUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: (600 / 900) * 1600
            height: 600

          expect(css).to.equal """
            @media (max-height: 299px) {
              .background {
                background-image: url('#{firstUrl}');
              }
            }

            @media (min-height: 300px) and (max-height: 599px) {
              .background {
                background-image: url('#{secondUrl}');
              }
            }

            @media (min-height: 600px) {
              .background {
                background-image: url('#{thirdUrl}');
              }
            }
          """


    describe 'selector option', ->

      context 'not provided', ->

        selector = null

        it 'should throw an error', ->
          exercise = ->
            {block, config, graph} = fixtures

            rig.breakpoints
              block: block
              config: config
              graph: graph
              params: {}
              property: 'width'
              selector: selector
              breakpoints: [800, 1200]

          expect(exercise).to.throw Error, 'selector not provided'


    describe 'breakpoints option', ->

      context 'not provided', ->

        breakpoints = null

        it 'should throw an error', ->
          exercise = ->
            {block, config, graph} = fixtures

            rig.breakpoints
              block: block
              config: config
              graph: graph
              params: {}
              property: 'width'
              selector: '.background'
              breakpoints: breakpoints

          expect(exercise).to.throw Error, 'breakpoints not provided'


      context 'unordered', ->

        breakpoints = [1200, 800]

        it 'should generate ordered media queries', ->
          {block, config, graph} = fixtures

          css = rig.breakpoints
            block: block
            config: config
            graph: graph
            params: {}
            property: 'width'
            selector: '.background'
            breakpoints: breakpoints

          firstUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 799
            height: (799 / 1600) * 900

          secondUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 1199
            height: (1199 / 1600) * 900

          thirdUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 1200
            height: (1200 / 1600) * 900

          expect(css).to.equal """
            @media (max-width: 799px) {
              .background {
                background-image: url('#{firstUrl}');
              }
            }

            @media (min-width: 800px) and (max-width: 1199px) {
              .background {
                background-image: url('#{secondUrl}');
              }
            }

            @media (min-width: 1200px) {
              .background {
                background-image: url('#{thirdUrl}');
              }
            }
          """


      context 'length 1', ->

        breakpoints = [800]

        it 'should generate media queries', ->
          {block, config, graph} = fixtures

          css = rig.breakpoints
            block: block
            config: config
            graph: graph
            params: {}
            property: 'width'
            selector: '.background'
            breakpoints: breakpoints

          firstUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 799
            height: (799 / 1600) * 900

          secondUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 800
            height: (800 / 1600) * 900

          expect(css).to.equal """
            @media (max-width: 799px) {
              .background {
                background-image: url('#{firstUrl}');
              }
            }

            @media (min-width: 800px) {
              .background {
                background-image: url('#{secondUrl}');
              }
            }
          """


      context 'length 2', ->

        breakpoints = [800, 1200]

        it 'should generate media queries', ->
          {block, config, graph} = fixtures

          css = rig.breakpoints
            block: block
            config: config
            graph: graph
            params: {}
            property: 'width'
            selector: '.background'
            breakpoints: breakpoints

          firstUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 799
            height: (799 / 1600) * 900

          secondUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 1199
            height: (1199 / 1600) * 900

          thirdUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 1200
            height: (1200 / 1600) * 900

          expect(css).to.equal """
            @media (max-width: 799px) {
              .background {
                background-image: url('#{firstUrl}');
              }
            }

            @media (min-width: 800px) and (max-width: 1199px) {
              .background {
                background-image: url('#{secondUrl}');
              }
            }

            @media (min-width: 1200px) {
              .background {
                background-image: url('#{thirdUrl}');
              }
            }
          """


    it 'should generate media queries', ->
      block =
        type: 'media'
        cover:
          src: 'https://a.com/b.png'
          width: 2160
          height: 1215

      {config, graph} = fixtures
      breakpoints = [576, 864, 1152, 1440, 1728, 2016]

      css = rig.breakpoints
        block: block
        config: config
        graph: graph
        params: {}
        property: 'width'
        selector: '.background'
        breakpoints: breakpoints

      firstUrl = imgflo config, graph,
        input: 'https://a.com/b.png'
        width: 575
        height: (575 / 2160) * 1215

      secondUrl = imgflo config, graph,
        input: 'https://a.com/b.png'
        width: 863
        height: (863 / 2160) * 1215

      thirdUrl = imgflo config, graph,
        input: 'https://a.com/b.png'
        width: 1151
        height: (1151 / 2160) * 1215

      fourthUrl = imgflo config, graph,
        input: 'https://a.com/b.png'
        width: 1439
        height: (1439 / 2160) * 1215

      fifthUrl = imgflo config, graph,
        input: 'https://a.com/b.png'
        width: 1727
        height: (1727 / 2160) * 1215

      sixthUrl = imgflo config, graph,
        input: 'https://a.com/b.png'
        width: 2015
        height: (2015 / 2160) * 1215

      seventhUrl = imgflo config, graph,
        input: 'https://a.com/b.png'
        width: 2016
        height: (2016 / 2160) * 1215

      expect(css).to.equal """
        @media (max-width: 575px) {
          .background {
            background-image: url('#{firstUrl}');
          }
        }

        @media (min-width: 576px) and (max-width: 863px) {
          .background {
            background-image: url('#{secondUrl}');
          }
        }

        @media (min-width: 864px) and (max-width: 1151px) {
          .background {
            background-image: url('#{thirdUrl}');
          }
        }

        @media (min-width: 1152px) and (max-width: 1439px) {
          .background {
            background-image: url('#{fourthUrl}');
          }
        }

        @media (min-width: 1440px) and (max-width: 1727px) {
          .background {
            background-image: url('#{fifthUrl}');
          }
        }

        @media (min-width: 1728px) and (max-width: 2015px) {
          .background {
            background-image: url('#{sixthUrl}');
          }
        }

        @media (min-width: 2016px) {
          .background {
            background-image: url('#{seventhUrl}');
          }
        }
      """


  describe 'srcset', ->

    validate fixtures.block, fixtures.config, fixtures.graph, (block, config, graph) ->
      rig.srcset
        block: block
        config: config
        graph: graph
        params: {}
        breakpoints: [800, 1200]


    describe 'breakpoints option', ->

      context 'not provided', ->

        breakpoints = null

        it 'should throw an error', ->
          exercise = ->
            {block, config, graph} = fixtures

            rig.srcset
              block: block
              config: config
              graph: graph
              params: {}
              breakpoints: breakpoints

          expect(exercise).to.throw Error, 'breakpoints not provided'


      context 'unordered', ->

        breakpoints = [600, 200]

        it 'should generate ordered src and srcset attribute values', ->
          {block, config, graph} = fixtures

          result = rig.srcset
            block: block
            config: config
            graph: graph
            params: {}
            breakpoints: breakpoints

          url = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 1600
            height: 900

          firstUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 200
            height: (200 / 1600) * 900

          secondUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 600
            height: (600 / 1600) * 900

          expect(result.src).to.equal url
          expect(result.srcset).to.equal "#{firstUrl} 200w, #{secondUrl} 600w"


      context 'length 1', ->

        breakpoints = [200]

        it 'should generate src and srcset attribute values', ->
          {block, config, graph} = fixtures

          result = rig.srcset
            block: block
            config: config
            graph: graph
            params: {}
            breakpoints: breakpoints

          url = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 1600
            height: 900

          firstUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 200
            height: (200 / 1600) * 900

          expect(result.src).to.equal url
          expect(result.srcset).to.equal "#{firstUrl} 200w"


      context 'length 2', ->

        breakpoints = [200, 600]

        it 'should generate src and srcset attribute values', ->
          {block, config, graph} = fixtures

          result = rig.srcset
            block: block
            config: config
            graph: graph
            params: {}
            breakpoints: breakpoints

          url = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 1600
            height: 900

          firstUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 200
            height: (200 / 1600) * 900

          secondUrl = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 600
            height: (600 / 1600) * 900

          expect(result.src).to.equal url
          expect(result.srcset).to.equal "#{firstUrl} 200w, #{secondUrl} 600w"


      describe 'breakpoints equal to the image width', ->

        breakpoints = [1600]

        it 'should produce a single srcset entry equal the image width', ->
          {block, config, graph} = fixtures

          result = rig.srcset
            block: block
            config: config
            graph: graph
            params: {}
            breakpoints: breakpoints

          url = imgflo config, graph,
            input: 'https://a.com/b.png'
            width: 1600
            height: 900

          expect(result.src).to.equal url
          expect(result.srcset).to.equal "#{url} 1600w"


      describe 'breakpoints greater than the image width', ->

        context 'single', ->

          breakpoints = [2000]

          it 'should produce a single srcset entry equal the image width', ->
            {block, config, graph} = fixtures

            result = rig.srcset
              block: block
              config: config
              graph: graph
              params: {}
              breakpoints: breakpoints

            url = imgflo config, graph,
              input: 'https://a.com/b.png'
              width: 1600
              height: 900

            expect(result.src).to.equal url
            expect(result.srcset).to.equal "#{url} 1600w"


        context 'multiple', ->

          breakpoints = [2000, 2400]

          it 'should produce a single srcset entry equal the image width', ->
            {block, config, graph} = fixtures

            result = rig.srcset
              block: block
              config: config
              graph: graph
              params: {}
              breakpoints: breakpoints

            url = imgflo config, graph,
              input: 'https://a.com/b.png'
              width: 1600
              height: 900

            expect(result.src).to.equal url
            expect(result.srcset).to.equal "#{url} 1600w"


      describe 'breakpoints less than, equal to, and greater than the image width', ->

          breakpoints = [1200, 1600, 2000, 2400]

          it 'should not produce srcset entries greater than the image width', ->
            {block, config, graph} = fixtures

            result = rig.srcset
              block: block
              config: config
              graph: graph
              params: {}
              breakpoints: breakpoints

            url = imgflo config, graph,
              input: 'https://a.com/b.png'
              width: 1600
              height: 900

            firstUrl = imgflo config, graph,
              input: 'https://a.com/b.png'
              width: 1200
              height: (1200 / 1600) * 900

            expect(result.src).to.equal url
            expect(result.srcset).to.equal "#{firstUrl} 1200w, #{url} 1600w"
