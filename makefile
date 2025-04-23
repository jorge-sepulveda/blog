serve:
	@IP=$$(ipconfig getifaddr en0 2>/dev/null || ip -4 addr show wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1); \
	if [ -z "$$IP" ]; then \
		echo "❌ Could not find your local Wi-Fi IP address."; \
		exit 1; \
	fi; \
	echo "📡 Starting Hugo server at: http://$$IP:1313"; \
	echo "📱 Open this link on your phone if it's on the same Wi-Fi network."; \
	hugo server -t terminal --bind 0.0.0.0 --baseURL http://$$IP:1313

local:
	hugo server -t terminal
