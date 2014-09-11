Peatio::Application.config.session_store :cookie_store,
  :key => '_eurocex_session',
  :expire_after => ENV['SESSION_EXPIRE'].to_i.minutes

