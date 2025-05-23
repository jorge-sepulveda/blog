+++
title = "Middleware Setup for REST API"
date = "2025-05-23T09:24:10-05:00"
tags = ["Golang", "Gorilla", "Middleware", "Dev"]
slug = "middleware-setup"
+++

# Setting Up Logging Middleware for Re4-pick-a-gun

We are at a pretty good spot with setting up a REST API for the pick-a-gun server. I have some routes and I'm able to get new JSON's. The overall plan is to throw this inside a docker container but I need one important thing. Logs, the make or break situation to determine if our application is actually doing something or giving us important error messages along the way. I want to use Kibana for monitoring these logs so we'll form our JSON to make it Kibana friendly. Technically, kibana will receieve any JSON for standard output but we have a nice little tool for making that easier. 

## Let's use some slog

Slog is the structured logging library that Google baked into the standard library a while back. I always think that it's a way to get people off of using Uber's Zap library but Zap is still the winner. For me, I'm not looking for anything performant and if I can get away with using the standard library, I prefer using that to crack down on dependencies. The simpler I can make it, the better. 

## Intercepting the API request. 

For every request I receive, I want to add logs with common metrics like which endpoint was hit, time to execute and other regular info. I joke about intercepting the request because we are straight up running some software that the user doesn't know about and it's only providing metrics to the lords of the software. Maybe we should look for another word.

This is where Gorilla really shines, they make it easy to add middleware to your routes by wrapping the software around requests and passing it along to the next handler. 

We'll make two stucts to wrap the response writer and add a status code into it.

```go
type responseWriter struct {
	http.ResponseWriter
	statusCode int
}

func (rw *responseWriter) WriteHeader(code int) {
	rw.statusCode = code
	rw.ResponseWriter.WriteHeader(code)
}
```

We'll then use this to build the logging middleware which will create the struct and grab the request's information and then "pass" it along to the next part of the request. A lot of middleware can be chained this way to handle different events.

```go
func LoggingMiddleware(logger *slog.Logger) mux.MiddlewareFunc {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			start := time.Now()

			rw := &responseWriter{ResponseWriter: w, statusCode: http.StatusOK}
			next.ServeHTTP(rw, r)

			duration := time.Since(start).Milliseconds()

			logger.Info("api_request", slog.Group("request",
				slog.String("method", r.Method),
				slog.String("path", r.URL.Path),
				slog.Int("status", rw.statusCode),
				slog.Int64("duration_ms", duration),
				slog.String("client_ip", r.RemoteAddr),
				slog.Time("timestamp", time.Now()),
			))

		})
	}
}
```

We are almost there, middleware is setup and now we need to hook it up to our server. 

{{< highlight go "linenos=inline, hl_lines=2 5 9" >}}
func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))

	r := mux.NewRouter()
	r.Use(LoggingMiddleware(logger))
	r.HandleFunc("/start", StartHandler).Methods("GET")
	r.HandleFunc("/roll", rollHandler).Methods("POST")
	r.HandleFunc("/load", loadHandler).Methods("POST")
	logger.Info("starting server", "port", 8080)
	http.ListenAndServe(":8080", r)
}
{{< /highlight >}}

And we are set! I will now be able to see the logs coming in when I send requests going to the server. Using the same payloads in the video from the [previous blog](../05/server-setup.md), the logs are looking like this. 

```
{"time":"2025-05-05T20:42:40.872946-05:00","level":"INFO","msg":"starting server","port":8080}
{"time":"2025-05-05T20:42:43.388772-05:00","level":"INFO","msg":"api_request","request":{"method":"GET","path":"/start","status":200,"duration":0,"client_ip":"127.0.0.1:57570","timestamp":"2025-05-05T20:42:43.388766-05:00"}}
{"time":"2025-05-05T20:42:43.675066-05:00","level":"INFO","msg":"api_request","request":{"method":"GET","path":"/start","status":200,"duration":0,"client_ip":"127.0.0.1:57570","timestamp":"2025-05-05T20:42:43.675057-05:00"}}
{"time":"2025-05-05T20:42:45.430022-05:00","level":"INFO","msg":"api_request","request":{"method":"POST","path":"/roll","status":200,"duration":0,"client_ip":"127.0.0.1:57570","timestamp":"2025-05-05T20:42:45.430014-05:00"}}
{"time":"2025-05-05T20:42:45.625123-05:00","level":"INFO","msg":"api_request","request":{"method":"POST","path":"/roll","status":200,"duration":0,"client_ip":"127.0.0.1:57570","timestamp":"2025-05-05T20:42:45.625112-05:00"}}
{"time":"2025-05-05T20:42:46.780732-05:00","level":"INFO","msg":"api_request","request":{"method":"POST","path":"/load","status":200,"duration":0,"client_ip":"127.0.0.1:57570","timestamp":"2025-05-05T20:42:46.780723-05:00"}}
{"time":"2025-05-05T20:42:47.890512-05:00","level":"INFO","msg":"api_request","request":{"method":"POST","path":"/roll","status":200,"duration":0,"client_ip":"127.0.0.1:57570","timestamp":"2025-05-05T20:42:47.890503-05:00"}}
```

And we're all set! I can now see what the server is doing along with some additional info. Once I feed these into kibana, it will be great to categorize this. I might make some additional middleware for authentication or some other form of control for the server. Gorilla makes it really easy to setup which is why I went for this instead of the standard library. It's possible to do this without needing a dependency, but I think Gorilla has a lot going for it. 
