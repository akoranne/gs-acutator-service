package hello;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.availability.AvailabilityChangeEvent;
import org.springframework.boot.availability.ReadinessState;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.atomic.AtomicLong;

@RestController
public class GreetingController {

    private static final Logger log = LoggerFactory.getLogger(GreetingController.class);
    private final ApplicationEventPublisher publisher;

    private static final String template = "Hello, %s!";
    public static final String HUMOR_API = "http://api.icndb.com/jokes/random";
    public static final String QUTOE_API = "https://gturnquist-quoters.cfapps.io/api/random";
    private final AtomicLong counter = new AtomicLong();

    private DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd-MM-yyyy hh:mm:ss");

    public GreetingController(ApplicationEventPublisher publisher) {
        this.publisher = publisher;
    }

    @RequestMapping("/")
    @ResponseBody
    public Greeting sayHello() {
        return new Greeting(counter.incrementAndGet(),
                String.format(template, "Stranger - " + fmt.format(LocalDateTime.now())));
    }

    @RequestMapping("/greeting")
    @ResponseBody
    public Greeting greeting(@RequestParam(name="name", required=false, defaultValue="Stranger") String name) {
        return new Greeting(counter.incrementAndGet(), String.format(template, name));
    }

    @RequestMapping("/joke")
    @ResponseBody
    public Greeting getJoke() {
        RestTemplate restTemplate = new RestTemplate();
        return new Greeting(counter.incrementAndGet(), restTemplate.getForObject(HUMOR_API, String.class));
    }

    @RequestMapping("/quote")
    @ResponseBody
    public Quote getQuote() {
        RestTemplate restTemplate = new RestTemplate();
        Quote quote = restTemplate.getForObject(QUTOE_API, Quote.class);
        log.info(quote.toString());
        return quote;
    }

    @RequestMapping("/down")
    public String down() {
        AvailabilityChangeEvent.publish(publisher, this, ReadinessState.REFUSING_TRAFFIC);
        return "down";
    }

    @RequestMapping("/up")
    public String up() {
        AvailabilityChangeEvent.publish(publisher, this, ReadinessState.ACCEPTING_TRAFFIC);
        return "up";
    }
}
