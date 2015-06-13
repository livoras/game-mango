config = require "./config"
template = require "art-template"

mainTpl = template.compile(require "../templates/main.tpl")
gameTpl = template.compile(require "../templates/game.tpl")
gameResultTpl = template.compile(require "../templates/game-result.tpl")
priceTpl = template.compile(require "../templates/price.tpl")
priceResultTpl = template.compile(require "../templates/price-result.tpl")

$mainPage = $(mainTpl(config)).hide()
$gamePage = $(gameTpl(config)).hide()
$gameResultPage = $(gameResultTpl(config)).hide()
$pricePage = $(priceTpl(config)).hide()
$priceResultPage = $(priceResultTpl(config)).hide()

$container = $ "#container"

$container.append $mainPage
$container.append $gamePage
$container.append $gameResultPage
$container.append $pricePage
$container.append $priceResultPage

module.exports = {$mainPage, $gamePage, $gameResultPage, $pricePage, $priceResultPage}
