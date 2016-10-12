require "../error"

module CrystalShards
  module Github
    module Response
      class Base
        def self.from_response(response)
          status = response.status_code
          body = response.body
          headers = response.headers

          case status
          when      400 then raise BadRequest.new nil
          when      401 then raise error_for_401(headers)
          when      403 then raise error_for_403(body)
          when      404 then raise NotFound.new nil
          when      405 then raise MethodNotAllowed.new nil
          when      406 then raise NotAcceptable.new nil
          when      409 then raise Conflict.new nil
          when      415 then raise UnsupportedMediaType.new nil
          when      422 then raise UnprocessableEntity.new nil
          when      451 then raise UnavailableForLegalReasons.new nil
          when 400..499 then raise ClientError.new nil
          when      500 then raise InternalServerError.new nil
          when      501 then raise NotImplemented.new nil
          when      502 then raise BadGateway.new nil
          when      503 then raise ServiceUnavailable.new nil
          when 500..599 then raise ServerError.new nil
          end

          from_json(body)
        end

        def self.error_for_401(headers)
          if OneTimePasswordRequired.required_header(headers)
            OneTimePasswordRequired.new nil, nil
          else
            Unauthorized.new nil, nil
          end
        end

        def self.error_for_403(body)
          if body =~ /rate limit exceeded/i
            TooManyRequests.new nil, nil
          elsif body =~ /login attempts exceeded/i
            TooManyLoginAttempts.new nil, nil
          elsif body =~ /abuse/i
            AbuseDetected.new nil, nil
          elsif body =~ /repository access blocked/i
            RepositoryUnavailable.new nil, nil
          elsif body =~ /email address must be verified/i
            UnverifiedEmail.new nil, nil
          elsif body =~ /account was suspended/i
            AccountSuspended.new nil, nil
          else
            Forbidden.new nil, nil
          end
        end
      end
    end
  end
end
