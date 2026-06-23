# encoding: utf-8

require "faraday"
require "bitbucket_rest_api/error"

module BitBucket
  class Response::RaiseError < Faraday::Middleware

    def on_complete(env)
      case env[:status].to_i
      when 400
        raise BitBucket::Error::BadRequest, env
      when 401
        raise BitBucket::Error::Unauthorized, env
      when 403
        raise BitBucket::Error::Forbidden, env
      when 404
        raise BitBucket::Error::NotFound, env
      when 422
        raise BitBucket::Error::UnprocessableEntity, env
      when 500
        raise BitBucket::Error::InternalServerError, env
      when 503
        raise BitBucket::Error::ServiceUnavailable, env
      when 400...600
        raise BitBucket::Error::ServiceError, env
      end
    end

  end
end
