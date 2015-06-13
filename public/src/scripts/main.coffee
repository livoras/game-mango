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

  $gamePage.find("div.mask a.button").click ->
    state.gender = $(this).attr "gender"
    hideGameMask()

  $gamePage.find("a.button.upload").click ->
    $("#image-upload").click()

  count = 0
  $(document).on "change", "#image-upload", null, ->
    $fileInput = $("#image-upload")
    count++
    console.log count
    if (!$fileInput.val()) then return
    $.ajaxFileUpload
      url: config.uploadUrl
      fileElementId: "image-upload"
      dataType: 'jsonp'
      success: (data)->
        data = JSON.parse $(data).html()
        showImage(data.path)
        $fileInput.replaceWith """
          <input type="file" name="image" id="image-upload" class="button button-long"></a>
        """
      error: (data)->
        showError data

showImage = (path)->
  $("#avatar").attr "src", path

showError = ->
  console.log data

hideGameMask = ->    
  $gamePage.find("div.mask").hide()

showGameMask = ->    
  $gamePage.find("div.mask").show()

next = ->
  showPage($gameResultPage)
  renderGameResult()

renderGameResult = ->  
  console.log 'render game result'

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

resetGameState = ->
  console.log 'reset game state'

showPage = ($page)->
  $(".page").hide()
  $page.show()

init();