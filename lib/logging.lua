local logging = {
  msgs = {}
}

function logging:log(msg)
  self.msgs[#self.msgs+1] = msg
end

logging.__call = logging.log

return logging
