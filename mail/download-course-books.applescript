using terms from application "Mail"
  on perform mail action with messages msgs for rule theRule
    tell application "Mail"
      repeat with msg in msgs
        try
          set body to content of msg as text
          do shell script("$HOME/scripts/download/download-coursebook.sh '" & body & "'")
          display notification "Coursebook downloaded!" with title "Coursebook Processing"
        end try
      end repeat
    end tell
  end perform mail action with messages
end using terms from
