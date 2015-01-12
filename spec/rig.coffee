{expect} = require 'chai'
rig = require '../index'
imgflo = require 'imgflo-url'


describe 'Responsive image generator', ->

  describe 'without a block', ->

    it 'should throw an error', ->
      exercise = ->
        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        rig.generate null, config, 'passthrough', {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 800
        }]

      expect(exercise).to.throw Error, 'block not provided'


  context 'with a block', ->

    describe.skip 'of invalid type', ->

      it 'should throw an error', ->
        exercise = ->
          fakeBlock =
            type: 'text'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          rig.generate fakeBlock, config, 'passthrough', {}, [{
            query: '(max-width: 503px)'
            selector: '.media, .background'
            width: 800
          }]

        expect(exercise).to.throw Error, 'block must be of type "media" or a valid sub-type'


    describe 'without a cover image', ->

      it 'should throw an error', ->
        exercise = ->
          fakeBlock =
            type: 'media'

          params =
            graph: 'passthrough'

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          rig.generate fakeBlock, config, 'passthrough', {}, [{
            query: '(max-width: 503px)'
            selector: '.media, .background'
            width: 800
          }]

        expect(exercise).to.throw Error, 'block must have a cover image'


    context 'with a cover image', ->

      describe 'without a src', ->

        it 'should throw an error', ->
          exercise = ->
            fakeBlock =
              type: 'media'
              cover:
                width: 1600
                height: 900

            config =
              server: 'https://imgflo.herokuapp.com/'
              key: process.env.IMGFLO_KEY
              secret: process.env.IMGFLO_SECRET

            rig.generate fakeBlock, config, 'passthrough', {}, [{
              query: '(max-width: 503px)'
              selector: '.media, .background'
              width: 800
            }]

          expect(exercise).to.throw Error, 'block cover image must have a src'


      describe 'without a width', ->

        it 'should throw an error', ->
          exercise = ->
            fakeBlock =
              type: 'media'
              cover:
                src: 'https://a.com/b.png'
                height: 900

            config =
              server: 'https://imgflo.herokuapp.com/'
              key: process.env.IMGFLO_KEY
              secret: process.env.IMGFLO_SECRET

            rig.generate fakeBlock, config, 'passthrough', {}, [{
              query: '(max-width: 503px)'
              selector: '.media, .background'
              width: 800
            }]

          expect(exercise).to.throw Error, 'block cover image must have a width'


      describe 'without a height', ->

        it 'should throw an error', ->
          exercise = ->
            fakeBlock =
              type: 'media'
              cover:
                src: 'https://a.com/b.png'
                width: 1600

            config =
              server: 'https://imgflo.herokuapp.com/'
              key: process.env.IMGFLO_KEY
              secret: process.env.IMGFLO_SECRET

            rig.generate fakeBlock, config, 'passthrough', {}, [{
              query: '(max-width: 503px)'
              selector: '.media, .background'
              width: 800
            }]

          expect(exercise).to.throw Error, 'block cover image must have a height'


  describe 'without an imgflo config object', ->

    it 'should throw an error', ->
      exercise = ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        rig.generate fakeBlock, null, 'passthrough', {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 800
        }]

      expect(exercise).to.throw Error, 'imgflo config not provided'


  describe 'without a graph name', ->

    it 'should throw an error', ->
      exercise = ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        rig.generate fakeBlock, config, null, {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 800
        }]

      expect(exercise).to.throw Error, 'imgflo graph name not provided'


  describe 'without any query items', ->

    it 'should throw an error', ->
      exercise = ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        rig.generate fakeBlock, config, 'passthrough', {}

      expect(exercise).to.throw Error, 'query items not provided'


  context 'with a query item', ->

    describe 'without a media query', ->

      it 'should throw an error', ->
        exercise = ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          rig.generate fakeBlock,config, 'passthrough', {}, [{
            selector: '.media, .background'
            width: 800
          }]

        expect(exercise).to.throw Error, 'media query not provided'


    describe 'without a selector', ->

      it 'should throw an error', ->
        exercise = ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          rig.generate fakeBlock, config, 'passthrough', {}, [{
            query: '(max-width: 503px)'
            width: 800
          }]

        expect(exercise).to.throw Error, 'selector not provided'


    describe 'without a width or height', ->

      it 'should throw an error', ->
        exercise = ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          rig.generate fakeBlock, config, 'passthrough', {}, [{
            query: '(max-width: 503px)'
            selector: '.media, .background'
          }]

        expect(exercise).to.throw Error, 'width or height not provided'


    describe 'specifying both width and height', ->

      it 'should throw an error', ->
        exercise = ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          rig.generate fakeBlock, config, 'gaussianblur', {}, [{
            query: '(max-width: 503px)'
            selector: '.media, .background'
            width: 800
            height: 450
          }]

        expect(exercise).to.throw Error, 'width or height must be provided, but not both'


    describe 'with a width larger than the original', ->

      it 'should use the original width', ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        css = rig.generate fakeBlock, config, 'passthrough', {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 1920
        }]

        url = imgflo config, 'passthrough',
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

      it 'should use the original height', ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        css = rig.generate fakeBlock, config, 'passthrough', {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          height: 1200
        }]

        url = imgflo config, 'passthrough',
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

      it 'should generate media queries', ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        css = rig.generate fakeBlock, config, 'passthrough', {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 400
        }, {
          query: '(min-width: 504px) and (max-width: 1007px)'
          selector: '.media, .background'
          width: 800
        }]

        firstUrl = imgflo config, 'passthrough',
          input: 'https://a.com/b.png'
          width: 400
          height: 225

        secondUrl = imgflo config, 'passthrough',
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

      it 'should generate media queries', ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        css = rig.generate fakeBlock, config, 'passthrough', {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          height: 225
        }, {
          query: '(min-width: 504px) and (max-width: 1007px)'
          selector: '.media, .background'
          height: 450
        }]

        firstUrl = imgflo config, 'passthrough',
          input: 'https://a.com/b.png'
          width: 400
          height: 225

        secondUrl = imgflo config, 'passthrough',
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

      it 'should generate media queries', ->
        fakeBlock =
          type: 'media'
          cover:
            src: 'https://a.com/b.png'
            width: 1600
            height: 900

        config =
          server: 'https://imgflo.herokuapp.com/'
          key: process.env.IMGFLO_KEY
          secret: process.env.IMGFLO_SECRET

        css = rig.generate fakeBlock, config, 'passthrough', {}, [{
          query: '(max-width: 503px)'
          selector: '.media, .background'
          width: 400
        }, {
          query: '(min-width: 504px) and (max-width: 1007px)'
          selector: '.media, .background'
          height: 450
        }]

        firstUrl = imgflo config, 'passthrough',
          input: 'https://a.com/b.png'
          width: 400
          height: 225

        secondUrl = imgflo config, 'passthrough',
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

        it 'should generate media queries', ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          params =
            'std-dev-x': 15
            'std-dev-y': 15

          css = rig.generate fakeBlock, config, 'gaussianblur', params, [{
            query: '(max-width: 503px)'
            selector: '.media, .background'
            width: 400
          }, {
            query: '(min-width: 504px) and (max-width: 1007px)'
            selector: '.media, .background'
            height: 450
          }]

          firstUrl = imgflo config, 'gaussianblur',
            input: 'https://a.com/b.png'
            width: 400
            height: 225
            'std-dev-x': 15
            'std-dev-y': 15

          secondUrl = imgflo config, 'gaussianblur',
            input: 'https://a.com/b.png'
            width: 800
            height: 450
            'std-dev-x': 15
            'std-dev-y': 15

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

    describe 'property param', ->

      context 'not provided', ->

        it 'should throw an error', ->
          exercise = ->
            fakeBlock =
              type: 'text'
              cover:
                src: 'https://a.com/b.png'
                width: 1600
                height: 900

            config =
              server: 'https://imgflo.herokuapp.com/'
              key: process.env.IMGFLO_KEY
              secret: process.env.IMGFLO_SECRET

            rig.breakpoints fakeBlock, config, 'passthrough', {}, null, '.background', [800, 1200]

          expect(exercise).to.throw Error, 'property not provided'


      context 'invalid', ->

        it 'should throw an error', ->
          exercise = ->
            fakeBlock =
              type: 'text'
              cover:
                src: 'https://a.com/b.png'
                width: 1600
                height: 900

            config =
              server: 'https://imgflo.herokuapp.com/'
              key: process.env.IMGFLO_KEY
              secret: process.env.IMGFLO_SECRET

            rig.breakpoints fakeBlock, config, 'passthrough', {}, 'widt', '.background', [800, 1200]

          expect(exercise).to.throw Error, 'invalid property provided'


      context 'width', ->

        it 'should generate media queries', ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          css = rig.breakpoints fakeBlock, config, 'passthrough', {}, 'width', '.background', [800, 1200]

          firstUrl = imgflo config, 'passthrough',
            input: 'https://a.com/b.png'
            width: 799
            height: (799 / 1600) * 900

          secondUrl = imgflo config, 'passthrough',
            input: 'https://a.com/b.png'
            width: 1199
            height: (1199 / 1600) * 900

          thirdUrl = imgflo config, 'passthrough',
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

        it 'should generate media queries', ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          css = rig.breakpoints fakeBlock, config, 'passthrough', {}, 'height', '.background', [300, 600]

          firstUrl = imgflo config, 'passthrough',
            input: 'https://a.com/b.png'
            width: (299 / 900) * 1600
            height: 299

          secondUrl = imgflo config, 'passthrough',
            input: 'https://a.com/b.png'
            width: (599 / 900) * 1600
            height: 599

          thirdUrl = imgflo config, 'passthrough',
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


    describe 'selector param', ->

      context 'not provided', ->

        it 'should throw an error', ->
          exercise = ->
            fakeBlock =
              type: 'text'
              cover:
                src: 'https://a.com/b.png'
                width: 1600
                height: 900

            config =
              server: 'https://imgflo.herokuapp.com/'
              key: process.env.IMGFLO_KEY
              secret: process.env.IMGFLO_SECRET

            rig.breakpoints fakeBlock, config, 'passthrough', {}, 'width', null, [800, 1200]

          expect(exercise).to.throw Error, 'selector not provided'


    describe 'breakpoints param', ->

      context 'not provided', ->

        it 'should throw an error', ->
          exercise = ->
            fakeBlock =
              type: 'text'
              cover:
                src: 'https://a.com/b.png'
                width: 1600
                height: 900

            config =
              server: 'https://imgflo.herokuapp.com/'
              key: process.env.IMGFLO_KEY
              secret: process.env.IMGFLO_SECRET

            rig.breakpoints fakeBlock, config, 'passthrough', {}, 'width', '.background', null

          expect(exercise).to.throw Error, 'breakpoints not provided'


      context 'unsorted', ->

        it 'should generate media queries', ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          css = rig.breakpoints fakeBlock, config, 'passthrough', {}, 'width', '.background', [1200, 800]

          firstUrl = imgflo config, 'passthrough',
            input: 'https://a.com/b.png'
            width: 799
            height: (799 / 1600) * 900

          secondUrl = imgflo config, 'passthrough',
            input: 'https://a.com/b.png'
            width: 1199
            height: (1199 / 1600) * 900

          thirdUrl = imgflo config, 'passthrough',
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

        it 'should generate media queries', ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          css = rig.breakpoints fakeBlock, config, 'passthrough', {}, 'width', '.background', [800]

          firstUrl = imgflo config, 'passthrough',
            input: 'https://a.com/b.png'
            width: 799
            height: (799 / 1600) * 900

          secondUrl = imgflo config, 'passthrough',
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

        it 'should generate media queries', ->
          fakeBlock =
            type: 'media'
            cover:
              src: 'https://a.com/b.png'
              width: 1600
              height: 900

          config =
            server: 'https://imgflo.herokuapp.com/'
            key: process.env.IMGFLO_KEY
            secret: process.env.IMGFLO_SECRET

          css = rig.breakpoints fakeBlock, config, 'passthrough', {}, 'width', '.background', [800, 1200]

          firstUrl = imgflo config, 'passthrough',
            input: 'https://a.com/b.png'
            width: 799
            height: (799 / 1600) * 900

          secondUrl = imgflo config, 'passthrough',
            input: 'https://a.com/b.png'
            width: 1199
            height: (1199 / 1600) * 900

          thirdUrl = imgflo config, 'passthrough',
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
      fakeBlock =
        type: 'media'
        cover:
          src: 'https://a.com/b.png'
          width: 2160
          height: 1215

      config =
        server: 'https://imgflo.herokuapp.com/'
        key: process.env.IMGFLO_KEY
        secret: process.env.IMGFLO_SECRET

      breakpoints = [576, 864, 1152, 1440, 1728, 2016]
      css = rig.breakpoints fakeBlock, config, 'passthrough', {}, 'width', '.background', breakpoints

      firstUrl = imgflo config, 'passthrough',
        input: 'https://a.com/b.png'
        width: 575
        height: (575 / 2160) * 1215

      secondUrl = imgflo config, 'passthrough',
        input: 'https://a.com/b.png'
        width: 863
        height: (863 / 2160) * 1215

      thirdUrl = imgflo config, 'passthrough',
        input: 'https://a.com/b.png'
        width: 1151
        height: (1151 / 2160) * 1215

      fourthUrl = imgflo config, 'passthrough',
        input: 'https://a.com/b.png'
        width: 1439
        height: (1439 / 2160) * 1215

      fifthUrl = imgflo config, 'passthrough',
        input: 'https://a.com/b.png'
        width: 1727
        height: (1727 / 2160) * 1215

      sixthUrl = imgflo config, 'passthrough',
        input: 'https://a.com/b.png'
        width: 2015
        height: (2015 / 2160) * 1215

      seventhUrl = imgflo config, 'passthrough',
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
