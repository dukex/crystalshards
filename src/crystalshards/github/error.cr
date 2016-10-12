module CrystalShards
  module Github
    class BadRequest < Exception
    end

    class NotFound < Exception
    end

    class MethodNotAllowed < Exception
    end

    class NotAcceptable < Exception
    end

    class Unauthorized < Exception
    end

    class Conflict < Exception
    end

    class UnsupportedMediaType < Exception
    end

    class UnprocessableEntity < Exception
    end

    class UnavailableForLegalReasons < Exception
    end

    class ClientError < Exception
    end

    class InternalServerError < Exception
    end

    class NotImplemented < Exception
    end

    class BadGateway < Exception
    end

    class BadRequest < Exception
    end

    class ServiceUnavailable < Exception
    end

    class ServerError < Exception
    end

    class TooManyRequests < Exception
    end

    class TooManyLoginAttempts < Exception
    end

    class AbuseDetected < Exception
    end

    class RepositoryUnavailable < Exception
    end

    class UnverifiedEmail < Exception
    end

    class AccountSuspended < Exception
    end

    class Forbidden < Exception
    end

    class OneTimePasswordRequired < Exception
      OTP_DELIVERY_PATTERN = /required; (\w+)/i

      def self.required_header(headers)
        OTP_DELIVERY_PATTERN.match headers["X-GitHub-OTP"].to_s
      end
    end
  end
end
