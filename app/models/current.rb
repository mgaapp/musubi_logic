class Current < ActiveSupport::CurrentAttributes
  # リクエストごとに安全にセッション情報を保持・参照するための設定
  attribute :session
  # Current.sessionからuserへアクセスを任せる
  delegate :user, to: :session, allow_nil: true
end
