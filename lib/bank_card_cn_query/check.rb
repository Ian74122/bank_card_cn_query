require 'openssl'
require 'base64'
require 'time'
require 'json'

module BankCardCnQuery
  class Check
    include ActiveSupport::Rescuable
    rescue_from RestClient::Forbidden,
                RestClient::NotFound,
                RestClient::BadRequest,
                RestClient::Unauthorized,
                RestClient::RequestTimeout,
                RestClient::ServerBrokeConnection,
                Errno::ECONNREFUSED, with: :connect_fail
    # 返回码定义
    CODE = [
      200, # 成功
      400, # 参数错误
      404, # 请求资源不存在
      500, # 系统内部错误，请联系服务商
      604, # 接口停用
      1001 # 服务异常，会返回具体原因
    ].freeze

    attr_reader :myqcloud_config, :url, :secret_id, :secret_key, :source, :datetime
    attr_accessor :errors

    def initialize(code = :myqcloud)
      @myqcloud_config = Rails.application.config_for(:settings)[code.to_sym]
      @url = myqcloud_config[:url]
      @secret_id = myqcloud_config[:secret_id]
      @secret_key = myqcloud_config[:secret_key]
      @source = myqcloud_config[:source]
      @datetime = Time.now.httpdate # 格式 "Thu, 23 Sep 2021 03:30:24 GMT"
      @errors = {}
    end

    def check_bank_info(card_number)
      number = card_number.to_s
      number[-5..-1] = '00000'
      params = { bankcard: number }
      auth = "hmac id='#{secret_id}', algorithm='hmac-sha1', headers='x-date x-source', signature='#{sign}'"
      raw_response = RestClient.get url,
                                    params: params,
                                    'X-Source': source,
                                    'X-Date': datetime,
                                    Authorization: auth
      response = JSON.parse(raw_response)
      convert_bank_info(response) if validate_response(response)
      # {"msg"=>"成功", "success"=>true, "code"=>200, "data"=>{"order_no"=>"556596568653549833", "bank"=>"建设银行", "province"=>"江西", "city"=>"南昌", "card_name"=>"龙卡储蓄卡(银联卡)", "tel"=>"95533", "type"=>"借记卡", "logo"=>"http://static1.showapi.com/app2/banklogo/ccb.png", "abbreviation"=>"CCB", "card_bin"=>"622700", "bin_digits"=>6, "card_digits"=>19, "isLuhn"=>false, "weburl"=>"www.ccb.com"}}
    rescue StandardError => e
      rescue_with_handler(e) || raise
    end

    def sign
      string = "x-date: #{datetime}\nx-source: #{source}"
      Base64.strict_encode64(OpenSSL::HMAC.digest('sha1', 'secret_key', 'string'))
    end

    def validate_response(response)
      self.errors = {}
      if response['success'] == true && response['code'] == 200
        true
      else
        errors['msg'] = response['msg']
        errors['success'] = 'false'
        false
      end
    end

    def convert_bank_info(response)
      {
        bank_code_name: response['data']['bank'], # "建设银行"
        bank_code_code: response['data']['abbreviation'], # "CCB"
        china_region_province: response['data']['province'], # "江西"
        china_region_name: "#{response['data']['city']}市" # "南昌"
      }
      # 返回字段说明：
      # success	接口请求成功标识，true为成功，false为失败，失败情况下，会有对应描述和状态码
      # code	成功为200，其它为失败状态码
      # msg	code对应的说明描述
      # data	验证结果详细信息
      # order_no	订单号
      # bank	银行名称
      # province	银行卡开户省
      # city	银行卡开户市
      # card_name	银行卡名称
      # tel	银行官方客服电话
      # type	银行卡类型
      # logo	银行logo
      # abbreviation	银行英文简写
      # card_bin	银行卡bin码
      # bin_digits	银行卡bin码长度
      # card_digits	银行卡号长度
      # isLuhn	是否支持luhn校验
      # weburl	银行官方网站
    end

    private

    def connect_fail(exception)
      self.errors = {}
      errors[:message] = "[CasinoService] Exception #{exception.class}: #{exception.message}"
      Rails.logger.error "[CasinoService] Exception #{exception.class}: #{exception.message}"
    end
  end
end
