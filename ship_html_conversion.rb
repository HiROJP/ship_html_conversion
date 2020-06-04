# encoding: utf-8

# URLにアクセスするためのライブラリの読み込み
require 'certified'
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

require 'tk'

# スクレイピング先のURL
#$url = 'https://robertsspaceindustries.com/pledge/ships/rsi-aurora/Aurora-ES'



#GUI部
def delete_text()
  $text2.delete('1.0', 'end')
  $text.delete('1.0', 'end')
end

def delete_input()
  $text2.delete('1.0', 'end')
  input_url($text.value)
end

Tk.root.title('船ページ変換くん for wiki V1.0 (@Made by HiRO.JP)')

TkLabel.new(nil, text: '船ページ(公式)のURLを入力してください').pack

$text = TkText.new(nil, height:2, width:15)
$text.pack('side' => 'top', 'fill' => 'both')

def input_url(page)
  $url = page.to_s
  main
end

label3 = TkMessage.new(nil, text: '(URLを入力後、右下にある「HTMLを生成」ボタンをクリックしてください)',aspect: 2000).pack

label1 = TkLabel.new(nil, text: '生成されたHTML',background:"#4682b4",foreground:"white")
label1.pack('side' => 'top', 'fill' => 'x')

button = TkButton.new(nil, text: 'HTMLを生成','command' => proc{delete_input})
button.pack('side' => 'right', 'fill' => 'y')

#button = TkButton.new(nil, text: '削除','command' => proc{$text2.insert("end","")})
#button.pack('side' => 'bottom', 'fill' => 'none')

#label1 = TkMessage.new(nil,text: $ship_txt, aspect: 500).pack

$text2 = TkText.new(nil,background:"#0f2e59",foreground:"white", height:35, width:110)
$text2.pack('side' => 'top')

button2 = TkButton.new(nil, 'text' => '全て削除する', 
  'command' => proc{delete_text})
button2.pack('fill' => 'x')



#label2 = TkMessage.new(nil,text: " (#last update 2020/03/02)  @Made by HiRO.JP", aspect: 1500)
#label2.pack('side' => 'bottom')
#---------ここまでGUI--------



#メインプログラム
def main()
  charset = nil
  html = open($url) do |f|
    charset = f.charset # 文字種別を取得
    f.read # htmlを読み込んで変数htmlに渡す
  end

  # htmlをパース(解析)してオブジェクトを生成
  doc = Nokogiri::HTML.parse(html, nil, charset)

  detas = []

  #船のTECHNICAL OVERVIEWデータ
  doc.xpath('//div[@class="l-sheet__block"]/p').each do |node|
    # タイトルを表示
    deta = node.inner_text
    detas.push(deta)
  end


  #船のマニュファクチャーを取得
  manu = doc.at('//div[@class="c-manufacturer__logo"]').to_s
  if manu.include?("Anvil")
      manu = "[[Anvil Aerospace]]"
    elsif manu.include?("Aegis")
      manu ="[[Aegis Dynamics]]"
    elsif manu.include?("Aopoa")
      manu ="[[AopoA]]"
    elsif manu.include?("Argo")
      manu ="[[ARGO Astronautics]]"
    elsif manu.include?("Banu")
      manu ="[[Banu (企業)]]"
    elsif manu.include?("Consolidated_outland")
      manu ="[[Consolidated Outland]]" 
    elsif manu.include?("Starlifter")
      manu ="[[Crusader Industries]]" 
    elsif manu.include?("Drake")
      manu ="[[Drake Interplanetary]]" 
    elsif manu.include?("Esperia")
      manu ="[[Esperia Inc.]]" 
    elsif manu.include?("Kruger")
      manu ="[[Kruger Intergalactic]]" 
    elsif manu.include?("MISC")
      manu ="[[Musashi Industrial and Starflight Concern]]"
    elsif manu.include?("Origin")
      manu ="[[Origin Jumpworks GmbH]]"
    elsif manu.include?("RSI")
      manu ="[[Roberts Space Industries]]"
    elsif manu.include?("Tumbril")
      manu ="[[Tumbril]]"
    elsif manu.include?("Vanduul")
      manu ="[[Vanduul (企業)]]"
    else 
      manu ="unknown"
  end

  #船の名前を取得
  name = doc.xpath('//div[@class="main-view"]/h2').inner_text

  #船の解説を取得
  info = doc.xpath('//div[@class="description clearfix"]//div[@class="excerpt"]').inner_text

  #船の価格を取得
  price = doc.xpath('//strong[@class="final-price"]').text

  if price.empty?
    price = "不明"
  end

  #info
  #puts info

  #船の開発状況を取得
  flight = doc.xpath('//div[@class="prod-status green"]/span').inner_text
  case flight 
  when "Flight Ready" then
    flight  = "飛行可能"
  else
    flight  = "開発中"
  end

  compo_pre = ""
  compo_list = []
  compo_hash = {}

  #船のコンポーネントを取得
  doc.css('//div[@class="l-sheet__cell l-sheet__cell--specbox"]').each do |node|
    compo = node.inner_html
    #puts compo
    compo = compo.to_s
    #p compo
    compo_one = compo.gsub(/"|'|<|>||\n|}/, '').gsub("/", '').gsub(/type:|name:|mounts:|component_size:|size:|details:|quantity:/, '').match(/{(.+)}/).to_s.gsub(/{|}/, '').gsub(/null|Manned|Remote|/,"null" => "empty","Manned" => "有人砲塔","Remote" => "リモート砲塔")
    #p compo_one
    #compo_one = compo_zero.gsub(/divclass=c-specboxjs-specboxno-mountsno-categoryno-dotdata-model=|divclass=c-specboxjs-specboxno-mountsno-quantityno-categoryno-dotdata-model=|divclass=c-specbox__backgrounddivdivclass=c-specbox__mountsv-secondary-font-color1divdivclass=c-specbox__sizeSdivdiv|divclass=c-specboxjs-specboxno-quantityno-categoryno-dotdata-model=|divclass=c-specboxjs-specboxno-mountsno-quantityno-dotdata-model=|divclass=c-specboxjs-specboxno-quantityno-dotdata-model=|divclass=c-specboxjs-specboxno-mountsno-categorytransparent-solidno-dotdata-model=|divclass=c-specboxjs-specboxno-categoryno-dotdata-model=|divclass=c-specboxno-mountsno-quantityno-sizeno-availableno-solidno-categorydivclass=c-specbox__backgrounddivdiv|divclass=c-specbox__backgrounddivdivclass=c-specbox__mountsv-secondary-font-color|2divdivclass=c-specbox__sizeSdivdiv|1divdivclass=c-specbox__categoryMdivdivclass=c-specbox__sizedivdiv|8divdivclass=c-specbox__categoryGdivdivclass=c-specbox__sizedivdiv|1divdivclass=c-specbox__quantity2divdivclass=c-specbox__size1divdiv|2divdivclass=c-specbox__quantity2divdivclass=c-specbox__size2divdiv|2divdivclass=c-specbox__quantity2divdivclass=c-specbox__size3divdiv|divclass=c-specboxjs-specboxno-quantityno-categorytransparent-solidno-dotdata-model=|divclass=c-specboxjs-specboxno-mountsno-quantityno-categorytransparent-solidno-dotdata-model=|{type:|name:|mounts:|component_size:|size:|details:|quantity:/, '')
    unless compo_one.empty?
      #取得したデータの , を条件として分割し配列化、さらに配列の[0]をkeyとして配列自体に紐づけて、それぞれのコンポーネントごとの配列を含んだhashを生成
      compo_list = compo_one.sub!(/manufacturer.*/m, "").split(",")
      #問題/ 同じkeyが登録されると内容を更新してしまう為後ろに数字を付ける
      if compo_hash.key?(compo_list[0] + "3")
        compo_list[0] = compo_list[0] + "4"
        compo_hash.store(compo_list[0], compo_list)
      elsif compo_hash.key?(compo_list[0] + "2")
        compo_list[0] = compo_list[0] + "3"
        compo_hash.store(compo_list[0], compo_list)
      elsif compo_hash.key?(compo_list[0])
        compo_list[0] = compo_list[0] + "2"
        compo_hash.store(compo_list[0], compo_list)
      else
        compo_list[0] = compo_list[0]
        compo_hash.store(compo_list[0], compo_list)
      end
    end

    #p rader_one
    #nil判定の文字列をsbu!では読み込むことが出来ない為条件分岐
    
  end


  #カテゴリネーム[0]、名前[1]、マウント[2]、コンポーネントサイズ[3]、サイズ[4]、詳細[5]、数[6]
  #{"type":"radar","name":"Radar","mounts":"1","component_size":"L","size":"L","details":"","quantity":"1","manufacturer":"TBD","component_class":"RSIAvionic"}

  #p compo_hash

  #暫定(後で効率化する)
  radar = compo_hash["radar"]
  radar2 = compo_hash["radar2"]
  radar3 = compo_hash["radar3"]
  radar4 = compo_hash["radar4"]

  computers = compo_hash["computers"]
  computers2 = compo_hash["computers2"]
  computers3 = compo_hash["computers3"]
  computers4 = compo_hash["computers4"]

  power_plants = compo_hash["power_plants"]
  power_plants2 = compo_hash["power_plants2"]
  power_plants3 = compo_hash["power_plants3"]
  power_plants4 = compo_hash["power_plants4"]

  coolers = compo_hash["coolers"]
  coolers2 = compo_hash["coolers2"]
  coolers3 = compo_hash["coolers3"]
  coolers4 = compo_hash["coolers4"]

  shield_generators = compo_hash["shield_generators"]
  shield_generators2 = compo_hash["shield_generators2"]
  shield_generators3 = compo_hash["shield_generators3"]
  shield_generators4 = compo_hash["shield_generators4"]

  fuel_intakes = compo_hash["fuel_intakes"]
  fuel_intakes2 = compo_hash["fuel_intakes2"]
  fuel_intakes3 = compo_hash["fuel_intakes3"]
  fuel_intakes4 = compo_hash["fuel_intakes4"]

  fuel_tanks = compo_hash["fuel_tanks"]
  fuel_tanks2 = compo_hash["fuel_tanks2"]
  fuel_tanks3 = compo_hash["fuel_tanks3"]
  fuel_tanks4 = compo_hash["fuel_tanks4"]

  quantum_drives = compo_hash["quantum_drives"]
  quantum_drives2 = compo_hash["quantum_drives2"]
  quantum_drives3 = compo_hash["quantum_drives3"]
  quantum_drives4 = compo_hash["quantum_drives4"]

  jump_modules = compo_hash["jump_modules"]
  jump_modules2 = compo_hash["jump_modules2"]
  jump_modules3 = compo_hash["jump_modules3"]
  jump_modules4 = compo_hash["jump_modules4"]

  quantum_fuel_tanks = compo_hash["quantum_fuel_tanks"]
  quantum_fuel_tanks2 = compo_hash["quantum_fuel_tanks2"]
  quantum_fuel_tanks3 = compo_hash["quantum_fuel_tanks3"]
  quantum_fuel_tanks4 = compo_hash["quantum_fuel_tanks4"]

  main_thrusters = compo_hash["main_thrusters"]
  main_thrusters2 = compo_hash["main_thrusters2"]
  main_thrusters3 = compo_hash["main_thrusters3"]
  main_thrusters4 = compo_hash["main_thrusters4"]

  maneuvering_thrusters = compo_hash["maneuvering_thrusters"]
  maneuvering_thrusters2 = compo_hash["maneuvering_thrusters2"]
  maneuvering_thrusters3 = compo_hash["maneuvering_thrusters3"]
  maneuvering_thrusters4 = compo_hash["maneuvering_thrusters4"]

  weapons = compo_hash["weapons"]
  weapons2 = compo_hash["weapons2"]
  weapons3 = compo_hash["weapons3"]
  weapons4 = compo_hash["weapons4"]

  turrets = compo_hash["turrets"]
  turrets2 = compo_hash["turrets2"]
  turrets3 = compo_hash["turrets3"]
  turrets4 = compo_hash["turrets4"]

  missiles = compo_hash["missiles"]
  missiles2 = compo_hash["missiles2"]
  missiles3 = compo_hash["missiles3"]
  missiles4 = compo_hash["missiles4"]

  utility_items = compo_hash["utility_items"]
  utility_items2 = compo_hash["utility_items2"]
  utility_items3 = compo_hash["utility_items3"]
  utility_items4 = compo_hash["utility_items4"]


  sec_detas = []

  detas.each do |text|
    #第１引数で渡した正規表現に該当する文字を、第２引数のパターンにそって置換してくれる
    sec = text.gsub(/ |\n|Snub|Small|Medium|Large|Capital|Multi|Combat|Transport|Exploration|Industrial|Support|Competition|Ground|Racing|Fighter|Stealth Fighter|Bomber|Stealth Bomber|Snub Fighter|Dropship|Interdiction|Gun Ship|Expedition|Pathfinder|Touring|Freight|Passenger|Data|Mining|Prospecting and Mining|Science|Salvage|Repair|Refuelling|Light|Heavy|Starter/, 
      " " => "", 
      "\n" => "", 
      "Snub" => "スナブ","Small" => "小型","Medium" => "中型","Large" => "大型","Capital" => "超大型",
      "Multi" => "多目的","Combat" => "戦闘","Transport" => "輸送",
      "Exploration" => "探査","Industrial" => "産業","Support" => "サポート",
      "Competition" => "競技","Ground" => "地上車両","Racing" => "レース",
      "Fighter" => "戦闘機","Stealth Fighter" => "ステルス戦闘機","Bomber" => "爆撃機",
      "Stealth Bomber" => "ステルス爆撃機","Snub Fighter" => "スナブ戦闘機",
      "Dropship" => "ドロップシップ","Interdiction" => "阻止","Gun Ship" => "ガンシップ",
      "Expedition" => "長距離探査","Pathfinder" => "近距離探査","Touring" => "旅行",
      "Freight" => "貨物輸送","Passenger" => "旅客","Data" => "データ輸送",
      "Mining" => "採掘","Prospecting and Mining" => "探鉱","Science" => "研究",
      "Salvage" => "サルベージ","Repair" => "修理","Refuelling" => "燃料補給",
      "Light" => "小型","Heavy" => "大型","Starter" => "スターター")

    sec_detas.push(sec)
  end

  File.open("html_text.txt","w:utf-8") do |text|
    text.print("{{Ship_Stats_Infobox" + "|" + 
    "title1" + " = " + 
    name.gsub("The", "") + "|" +
    "製造元" + " = " + manu + "|" + 
    "用途" + " = " + sec_detas[0] + "|" + 
    "開発状況" + " = " + flight + "|" + 
    "価格" + " = " + price + "|" + 
    "サイズ" + " = " + sec_detas[5] + "|" + 
    "全長" + " = " + sec_detas[2] + "|" + 
    "全幅" + " = " + sec_detas[3] + "|" + 
    "全高" + " = " + sec_detas[4] + "|" + 
    "重量" + " = " + sec_detas[6] + "|" + 
    "貨物積載量" + " = " + sec_detas[7] + "|" + 
    "乗員" + " = " + sec_detas[10] + " / " + sec_detas[11] + "|" + 
    "ベッド数" + " = " + "不明" + "|" + 
    "scm速度" + " = " + sec_detas[8] + "|" + 
    "afb速度" + " = " + sec_detas[9] + "|" + 
    "pitch/yaw/roll_max" + " = " + sec_detas[12].gsub("deg/s","") + " / " + sec_detas[13].gsub("deg/s","")+ " / "  + sec_detas[14] + "|" + 
    "x/y/z_acc" + " = " + sec_detas[15].gsub("m/s/s","")+ " / "  + sec_detas[16].gsub("m/s/s","")+ " / "  + sec_detas[17] + "|")

    #レーダー
    unless radar.nil?
      text.print("レーダー" + " = " + radar[2] + " × " + "[[" + radar[1] + "]]" + " (" + radar[3] + ")" + "\n")
    end
    unless radar2.nil?
      text.print(radar2[2] + " × " + "[[" +  radar2[1] + "]]"  + " (" + radar2[3] + ")" + "\n")
    end
    unless radar3.nil?
      text.print(radar3[2] + " × " + "[[" +  radar3[1] + "]]"   + " (" + radar3[3] + ")" + "\n")
    end
    unless radar4.nil?
      text.print(radar4[2] + " × " + "[[" +  radar4[1] + "]]"   + " (" + radar4[3] + ")" + "\n")
    end
    text.print("|")

    #コンピュータ
    unless computers.nil?
      text.print("コンピュータ" + " = " + computers[2] + " × " + "[[" +  computers[1] + "]]"  + " (" + computers[3] + ")" + "\n")
    end
    unless computers2.nil?
      text.print(computers2[2] + " × " + "[[" +  computers2[1] + "]]"  + " (" + computers2[3] + ")" + "\n")
    end
    unless computers3.nil?
      text.print(computers3[2] + " × " + "[[" +  computers3[1] + "]]"  + " (" + computers3[3] + ")" + "\n")
    end
    unless computers4.nil?
      text.print(computers4[2] + " × " + "[[" +  computers4[1] + "]]"  + " (" + computers4[3] + ")" + "\n")
    end
    text.print("|")

    #燃料インテーク
    unless fuel_intakes.nil?
      text.print("燃料インテーク" + " = " + fuel_intakes[2] + " × " + "[[" +  fuel_intakes[1] + "]]"  + " (" + fuel_intakes[3] + ")" + "\n")
    end
    unless fuel_intakes2.nil?
      text.print(fuel_intakes2[2] + " × " + "[[" +  fuel_intakes2[1] + "]]"  + " (" + fuel_intakes2[3] + ")" + "\n")
    end
    unless fuel_intakes3.nil?
      text.print(fuel_intakes3[2] + " × " + "[[" +  fuel_intakes3[1] + "]]"  + " (" + fuel_intakes3[3] + ")" + "\n")
    end
    unless fuel_intakes4.nil?
      text.print(fuel_intakes4[2] + " × " + "[[" +  fuel_intakes4[1] + "]]"  + " (" + fuel_intakes4[3] + ")" + "\n")
    end
    text.print("|")

    #燃料タンク
    unless fuel_tanks.nil?
      text.print("燃料タンク" + " = " + fuel_tanks[2] + " × " + "[[" +  fuel_tanks[1] + "]]"  + " (" + fuel_tanks[3] + ")" + "\n")
    end
    unless fuel_tanks2.nil?
      text.print(fuel_tanks2[2] + " × " + "[[" +  fuel_tanks2[1] + "]]"  + " (" + fuel_tanks2[3] + ")" + "\n")
    end
    unless fuel_tanks3.nil?
      text.print(fuel_tanks3[2] + " × " + "[[" +  fuel_tanks3[1] + "]]"  + " (" + fuel_tanks3[3] + ")" + "\n")
    end
    unless fuel_tanks4.nil?
      text.print(fuel_tanks4[2] + " × " + "[[" +  fuel_tanks4[1] + "]]"  + " (" + fuel_tanks4[3] + ")" + "\n")
    end
    text.print("|")
    
    #量子ドライブ
    unless quantum_drives.nil?
      text.print("量子ドライブ" + " = " + quantum_drives[2] + " × " + "[[" +  quantum_drives[1] + "]]"  + " (" + quantum_drives[3] + ")" + "\n")
    end
    unless quantum_drives2.nil?
      text.print(quantum_drives2[2] + " × " + "[[" +  quantum_drives2[1] + "]]"  + " (" + quantum_drives2[3] + ")" + "\n")
    end
    unless quantum_drives3.nil?
      text.print(quantum_drives3[2] + " × " + "[[" +  quantum_drives3[1] + "]]"  + " (" + quantum_drives3[3] + ")" + "\n")
    end
    unless quantum_drives4.nil?
      text.print(quantum_drives4[2] + " × " + "[[" +  quantum_drives4[1] + "]]"  + " (" + quantum_drives4[3] + ")" + "\n")
    end
    text.print("|")

    #ジャンプモジュール
    unless jump_modules.nil?
      text.print("ジャンプモジュール" + " = " + jump_modules[2] + " × " + "[[" +  jump_modules[1] + "]]"  + " (" + jump_modules[3] + ")" + "\n")
    end
    unless jump_modules2.nil?
      text.print(jump_modules2[2] + " × " + "[[" +  jump_modules2[1] + "]]"  + " (" + jump_modules2[3] + ")" + "\n")
    end
    unless jump_modules3.nil?
      text.print(jump_modules3[2] + " × " + "[[" +  jump_modules3[1] + "]]"  + " (" + jump_modules3[3] + ")" + "\n")
    end
    unless jump_modules4.nil?
      text.print(jump_modules4[2] + " × " + "[[" +  jump_modules4[1] + "]]"  + " (" + jump_modules4[3] + ")" + "\n")
    end
    text.print("|")

    #量子燃料タンク
    unless quantum_fuel_tanks.nil?
      text.print("量子燃料タンク" + " = " + quantum_fuel_tanks[2] + " × " + "[[" +  quantum_fuel_tanks[1] + "]]"  + " (" + quantum_fuel_tanks[3] + ")" + "\n")
    end
    unless quantum_fuel_tanks2.nil?
      text.print(quantum_fuel_tanks2[2] + " × " + "[[" +  quantum_fuel_tanks2[1] + "]]"  + " (" + quantum_fuel_tanks2[3] + ")" + "\n")
    end
    unless quantum_fuel_tanks3.nil?
      text.print(quantum_fuel_tanks3[2] + " × " + "[[" +  quantum_fuel_tanks3[1] + "]]"  + " (" + quantum_fuel_tanks3[3] + ")" + "\n")
    end
    unless quantum_fuel_tanks4.nil?
      text.print(quantum_fuel_tanks4[2] + " × " + "[[" +  quantum_fuel_tanks4[1] + "]]"  + " (" + quantum_fuel_tanks4[3] + ")" + "\n")
    end
    text.print("|")

    #メインスラスター
    unless main_thrusters.nil?
      text.print("メインスラスター" + " = " + main_thrusters[2] + " × " + "[[" +  main_thrusters[1] + "]]"  + " (" + main_thrusters[3] + ")" + "\n")
    end
    unless main_thrusters2.nil?
      text.print(main_thrusters2[2] + " × " + "[[" +  main_thrusters2[1] + "]]"  + " (" + main_thrusters2[3] + ")" + "\n")
    end
    unless main_thrusters3.nil?
      text.print(main_thrusters3[2] + " × " + "[[" +  main_thrusters3[1] + "]]"  + " (" + main_thrusters3[3] + ")" + "\n")
    end
    unless main_thrusters4.nil?
      text.print(main_thrusters4[2] + " × " + "[[" +  main_thrusters4[1] + "]]"  + " (" + main_thrusters4[3] + ")" + "\n")
    end
    text.print("|")

    #制御スラスター
    unless maneuvering_thrusters.nil?
      text.print("制御スラスター" + " = " + maneuvering_thrusters[2] + " × " + "[[" +  maneuvering_thrusters[1] + "]]"  + " (" + maneuvering_thrusters[3] + ")" + "\n")
    end
    unless maneuvering_thrusters2.nil?
      text.print(maneuvering_thrusters2[2] + " × " + "[[" +  maneuvering_thrusters2[1] + "]]"  + " (" + maneuvering_thrusters2[3] + ")" + "\n")
    end
    unless maneuvering_thrusters3.nil?
      text.print(maneuvering_thrusters3[2] + " × " + "[[" +  maneuvering_thrusters3[1] + "]]"  + " (" + maneuvering_thrusters3[3] + ")" + "\n")
    end
    unless maneuvering_thrusters4.nil?
      text.print(maneuvering_thrusters4[2] + " × " + "[[" +  maneuvering_thrusters4[1] + "]]"  + " (" + maneuvering_thrusters4[3] + ")" + "\n")
    end
    text.print("|")

    #パワープラント
    unless power_plants.nil?
      text.print("パワープラント" + " = " + power_plants[2] + " × " + "[[" +  power_plants[1] + "]]"  + " (" + power_plants[3] + ")" + "\n")
    end
    unless power_plants2.nil?
      text.print(power_plants2[2] + " × " + "[[" +  power_plants2[1] + "]]"  + " (" + power_plants2[3] + ")" + "\n")
    end
    unless power_plants3.nil?
      text.print(power_plants3[2] + " × " + "[[" +  power_plants3[1] + "]]"  + " (" + power_plants3[3] + ")" + "\n")
    end
    unless power_plants4.nil?
      text.print(power_plants4[2] + " × " + "[[" +  power_plants4[1] + "]]"  + " (" + power_plants4[3] + ")" + "\n")
    end
    text.print("|")

    #クーラー
    unless coolers.nil?
      text.print("クーラー" + " = " + coolers[2] + " × " + "[[" +  coolers[1] + "]]"  + " (" + coolers[3] + ")" + "\n")
    end
    unless coolers2.nil?
      text.print(coolers2[2] + " × " + "[[" +  coolers2[1] + "]]"  + " (" + coolers2[3] + ")" + "\n")
    end
    unless coolers3.nil?
      text.print(coolers3[2] + " × " + "[[" +  coolers3[1] + "]]"  + " (" + coolers3[3] + ")" + "\n")
    end
    unless coolers4.nil?
      text.print(coolers4[2] + " × " + "[[" +  coolers4[1] + "]]"  + " (" + coolers4[3] + ")" + "\n")
    end
    text.print("|")

    #シールドジェネレータ
    unless shield_generators.nil?
      text.print("シールドジェネレータ" + " = " + shield_generators[2] + " × " + "[[" +  shield_generators[1] + "]]"  + " (" + shield_generators[3] + ")" + "\n")
    end
    unless shield_generators2.nil?
      text.print(shield_generators2[2] + " × " + "[[" +  shield_generators2[1] + "]]"  + " (" + shield_generators2[3] + ")" + "\n")
    end
    unless shield_generators3.nil?
      text.print(shield_generators3[2] + " × " + "[[" +  shield_generators3[1] + "]]"  + " (" + shield_generators3[3] + ")" + "\n")
    end
    unless shield_generators4.nil?
      text.print(shield_generators4[2] + " × " + "[[" +  shield_generators4[1] + "]]"  + " (" + shield_generators4[3] + ")" + "\n")
    end
    text.print("|")

    #武装
    #コンポーネントサイズとマウントサイズの差でマウントの有無を判断する
    unless weapons.nil?
      if weapons[4] == weapons[3]
        text.print("武装" + " = " + weapons[2] + " × " + "[[S" + weapons[4] + " Mount]]" + "\n" + ":")
      elsif weapons[4] >= weapons[3]
        text.print("武装" + " = " + weapons[2] + " × " + "[[S" + weapons[4] + " Gimbal Mount]]" + "\n" + ":")
      end
      text.print(weapons[6] + " × " + "[[" + weapons[1] + "]]" + " (" + weapons[3] + ")" + "\n" )
    end
    
    unless weapons2.nil?
      if weapons2[4] == weapons2[3]
        text.print(weapons2[2] + " × " + "[[S" + weapons2[4] + " Mount]]" + "\n" + ":")
      elsif weapons2[4] >= weapons2[3]
        text.print(weapons2[2] + " × " + "[[S" + weapons2[4] + " Gimbal Mount]]" + "\n" + ":")
      end
      text.print(weapons2[6] + " × " + "[[" + weapons2[1] + "]]" + " (" + weapons2[3] + ")" + "\n" )
    end

    unless weapons3.nil?
      if weapons3[4] == weapons3[3]
        text.print(weapons2[2] + " × " + "[[S" + weapons2[4] + " Mount]]" + "\n" + ":")
      elsif weapons3[4] >= weapons3[3]
        text.print(weapons3[2] + " × " + "[[S" + weapons3[4] + " Gimbal Mount]]" + "\n" + ":")
      end
      text.print(weapons3[6] + " × " + "[[" + weapons3[1] + "]]" + " (" + weapons3[3] + ")" + "\n" )
    end

    unless weapons4.nil?
      if weapons4[4] == weapons4[3]
        text.print(weapons4[2] + " × " + "[[S" + weapons4[4] + " Mount]]" + "\n" + ":")
      elsif weapons4[4] >= weapons4[3]
        text.print(weapons4[2] + " × " + "[[S" + weapons4[4] + " Gimbal Mount]]" + "\n" + ":")
      end
      text.print(weapons4[6] + " × " + "[[" + weapons4[1] + "]]" + " (" + weapons4[3] + ")")
    end
    text.print("|")

    #砲塔
    unless turrets.nil?
      if turrets[5].empty?
        turrets[5] = "TBD"
      end
      text.print("砲塔" + " = " + turrets[6] + " × " + turrets[5] + "\n" + ":" + turrets[2] + " × " + "[[" + turrets[1] + "]]" + " (" + turrets[3] + ")" )
    end
    unless turrets2.nil?
      if turrets2[5].empty?
        turrets2[5] = "TBD"
      end
      text.print("\n" + turrets2[6] + " × " + turrets2[5] + "\n" + ":"  + turrets2[2] + " × " + "[[" + turrets2[1] + "]]" + " (" + turrets2[3] + ")")
    end
    unless turrets3.nil?
      if turrets3[5].empty?
        turrets3[5] = "TBD"
      end
      text.print("\n" + turrets3[6] + " × " + turrets3[5] + "\n" + ":"  + turrets3[2] + " × " + "[[" + turrets3[1] + "]]" + " (" + turrets3[3] + ")")
    end
    unless turrets4.nil?
      if turrets4[5].empty?
        turrets4[5] = "TBD"
      end
      text.print("\n" + turrets4[6] + " × " + turrets4[5] + "\n" + ":"  + turrets4[2] + " × " + "[[" + turrets4[1] + "]]" + " (" + turrets4[3] + ")")
    end
    text.print("|")


    #ミサイル
    unless missiles.nil?
      if missiles[5].empty?
        missiles[5] = "TBD"
      end
      text.print("ミサイル" + " = " + missiles[2] + " × " + "[[" + missiles[5] + "]]" + " (" + missiles[4] + ") " + "\n" + ":" + missiles[6] + " × " + "[[" + missiles[1] + "]]" + " (" + missiles[3] + ")" + "\n")
    end
    unless missiles2.nil?
      if missiles2[5].empty?
        missiles2[5] = "TBD"
      end
      text.print(missiles2[2] + " × " + "[[" + missiles2[5] + "]]" + " (" + missiles2[4] + ") " + "\n" + ":"  + missiles2[6] + " × " + "[[" + missiles2[1] + "]]" + " (" + missiles2[3] + ")" + "\n")
    end
    unless missiles3.nil?
      if missiles3[5].empty?
        missiles3[5] = "TBD"
      end
      text.print(missiles3[2] + " × " + "[[" + missiles3[5] + "]]" + " (" + missiles3[4] + ") " + "\n" + ":" + missiles3[6] + " × " + "[[" + missiles3[1] + "]]" + " (" + missiles3[3] + ")" + "\n")
    end
    unless missiles4.nil?
      if missiles4[5].empty?
        missiles4[5] = "TBD"
      end
      text.print(missiles4[2] + " × " + "[[" + missiles4[5] + "]]" + " (" + missiles4[4] + ") " + "\n" + ":" + missiles4[6] + " × " + "[[" + missiles4[1] + "]]" + " (" + missiles4[3] + ")" + "\n")
    end
    text.print("|")

    #ユーティリティ
    unless utility_items.nil?
      text.print("ユーティリティ" + " = " + utility_items[2] + " × " + "[[" + "S" + utility_items[4] + " " + "Mount" + "]]" + "\n" + ":" + utility_items[6] + " × " + "[[" + utility_items[1] + "]]" + " (" + utility_items[3] + ")" )
    end
    unless utility_items2.nil?
      text.print(utility_items2[2] + " × "  + "[[" + "S" + utility_items2[4] + " " + "Mount" + "]]" + "\n" + ":" + utility_items2[6] + " × " + "[[" + utility_items2[1] + "]]" + " (" + utility_items2[3] + ")")
    end
    unless utility_items3.nil?
      text.print(utility_items3[2] + " × "  + "[[" + "S" + utility_items3[4] + " " + "Mount" + "]]" + "\n" + ":" + utility_items3[6] + " × " + "[[" + utility_items3[1] + "]]" + " (" + utility_items3[3] + ")")
    end
    unless utility_items4.nil?
      text.print(utility_items4[2] + " × "  + "[[" + "S" + utility_items4[4] + " " + "Mount" + "]]" + "\n" + ":" + utility_items4[6] + " × " + "[[" + utility_items4[1] + "]]" + " (" + utility_items4[3] + ")")
    end

    text.print("}}")
    text.print("\n" + "== 概要 ==" + "\n" + info.strip + "\n" + "== 機体解説 ==" + "\n" + "== リンク ==" + "\n" + "[" + $url +  " 公式サイト:" + name + "]" + "\n" + "== ギャラリー ==")
  end

  txt = File.open("html_text.txt","r:utf-8")
  $ship_txt = txt.read  # 全て読み込む
  txt.close
  $text2.insert('end', $ship_txt)
  sleep 0.5
end




Tk.mainloop

#puts $ship_txt

#カテゴリネーム[0]、名前[1]、マウント[2]、コンポーネントサイズ[3]、サイズ[4]、詳細[5]、数[6]

#load './ship_html_gui.rb'

