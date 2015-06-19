config = require "./modules/config"
common = require "./modules/common"
state = require "./modules/state"
{$mainPage, $gamePage, $gameResultPage, $pricePage, $priceResultPage} = common

init = ->
  initMainPage()
  initGamePage()
  initGameResultPage()
  initPricePage()
  initPriceResultPage()
  showPage($gamePage)

# Main Controller
initMainPage = ->
  $mainPage.find(".game-starter").click ->
    restartGame()

#=================== Game Controller =====================
initGamePage = ->
  initGameActions()

  $(document).on "change", "#image-upload", null, ->
    $fileInput = $("#image-upload")
    if (!$fileInput.val()) then return
    $.ajaxFileUpload
      url: config.uploadUrl
      fileElementId: "image-upload"
      dataType: 'jsonp'
      success: (data)->
        data = JSON.parse $(data).html()
        if data.result is "OK"
          state.image = data.path
          showImage(data.path)
          $fileInput.replaceWith """
            <input type="file" name="image" id="image-upload" class="button button-long"></a>
          """
          showGameActions()
          hideUploadBtn();
        else
          showError data

initGameActions = ->
  $gamePage.find("a.button.replay").click ->
    restartGame()

  $gamePage.find("div.mask a.button").click ->
    state.gender = $(this).attr "gender"
    hideGameMask()

  $gamePage.find("a.button.upload").click ->
    $("#image-upload").click()

  $gamePage.find("a.button.next").click ->
    next()

showGameActions = ->
  $gamePage.find("div.actions").show()

hideGameActions = ->
  $gamePage.find("div.actions").hide()

showUploadBtn = ->  
  $gamePage.find("div.upload").show()

hideUploadBtn = ->  
  $gamePage.find("div.upload").hide()

showImage = (path)->
  $("#avatar").attr "src", path

showError = (data)->
  if data.result is "Not a image file!"
    alert "请上传图片文件"

hideGameMask = ->    
  $gamePage.find("div.mask").hide()

showGameMask = ->    
  $gamePage.find("div.mask").show()

next = ->
  image = "http://www.faceplusplus.com/wp-content/themes/faceplusplus/assets/img/demo/thumbnail/16.jpg?v=2"
  faceUrl = "http://apicn.faceplusplus.com/v2/detection/detect?api_key=f34b1299bea284030a64c5be59bb740f&api_secret=kyPK61kwrPM2QgYRri4Y1QWq7mBnQM93&url="
  showPage($gameResultPage)
  $.ajax
    url: "#{faceUrl}#{image}"
    type: "GET"
    success: renderGameResult

renderGameResult = (imgData)->  
  console.log 'render game result', imgData
  $result = $("#game-result")
  if imgData.face.length is 0 then return alert "未识别到人脸"
  face = imgData.face[0]
  padding = 1.5 #为了包含下巴！
  faceWidth = face.position.width / 100 * imgData.img_width * padding
  faceHeight = face.position.height / 100 * imgData.img_height * padding
  $result.css 
    "width": "#{faceWidth}px"
    "height": "#{faceHeight}px"
    "background-image": "url(#{imgData.url})"
    "background-position-x": "-#{face.position.center.x / 100 * imgData.img_width - faceWidth / 2}px"
    "background-position-y": "-#{face.position.center.y / 100 * imgData.img_height - faceHeight / 2}px"
    "background-repeat": "no-repeat"
    "-webkit-border-radius": "100%"

#===================== Game result Controller ===============
initGameResultPage = ->
  $gameResultPage.find("a.button.again").click -> restartGame()
  $gameResultPage.find("a.button.price").click -> showPage $pricePage

# Price Page Controller
initPricePage = ->
  initPricePageActions()
  hideNumberMask()

initPricePageActions = ->
  $phoneNumberInput = $pricePage.find("input.number")
  $pricePage.find("a.button.sure").click ->
    number = $phoneNumberInput.val()
    PHONE_NUMBER_REG = /^\d{11}$/
    if PHONE_NUMBER_REG.test number
      renderPriceResult(number)
      showPage $priceResultPage
    else
      showNumberMask()
  $pricePage.find("div.mask a").click ->
    hideNumberMask()

renderPriceResult = (phoneNumber)->
  console.log 'render price result', phoneNumber

showNumberMask = ->
  $pricePage.find("div.mask").show()

hideNumberMask = ->
  $pricePage.find("div.mask").hide()

#=================== Price Result Page =====================
initPriceResultPage = ->
  initPriceResultPageActions()
  hideShareMask()

initPriceResultPageActions = ->  
  $priceResultPage.find("a.button.change").click -> restartGame()
  $priceResultPage.find("a.button.share").click -> showShareMask()
  $priceResultPage.find("div.mask a.button.cancel").click -> hideShareMask()

hideShareMask = ->
  $priceResultPage.find("div.mask").hide()

showShareMask = ->
  $priceResultPage.find("div.mask").show()

# common fns
restartGame = ->
  resetGameState()
  showPage($gamePage)
  showGameMask()
  showUploadBtn()
  hideGameActions()
  $("#avatar").removeAttr("src")
  $("#game-result").removeAttr "style"

resetGameState = ->
  console.log 'reset game state'

showPage = ($page)->
  $(".page").hide()
  $page.show()

init();
next()