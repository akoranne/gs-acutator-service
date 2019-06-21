package hello;

import java.util.concurrent.atomic.AtomicLong;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

@Controller
public class GreetingController {

    private static final Logger log = LoggerFactory.getLogger(GreetingController.class);

    private static final String template = "Hello, %s!";
    public static final String HUMOR_API = "http://api.icndb.com/jokes/random";
    public static final String QUTOE_API = "https://gturnquist-quoters.cfapps.io/api/random";
    private final AtomicLong counter = new AtomicLong();

    @GetMapping("/")
    @ResponseBody
    public Greeting sayHello() {
        return new Greeting(counter.incrementAndGet(), String.format(template, "Stranger"));
    }

    @GetMapping("/greeting")
    @ResponseBody
    public Greeting greeting(@RequestParam(name="name", required=false, defaultValue="Stranger") String name) {
        return new Greeting(counter.incrementAndGet(), String.format(template, name));
    }

    //
    @GetMapping("/joke")
    @ResponseBody
    public Greeting getJoke() {
        RestTemplate restTemplate = new RestTemplate();
        return new Greeting(counter.incrementAndGet(), restTemplate.getForObject(HUMOR_API, String.class));
    }

    //
    @GetMapping("/quote")
    @ResponseBody
    public Quote getQutoe() {
        RestTemplate restTemplate = new RestTemplate();
        Quote quote = restTemplate.getForObject(QUTOE_API, Quote.class);
        log.info(quote.toString());
        return quote;
    }

}
