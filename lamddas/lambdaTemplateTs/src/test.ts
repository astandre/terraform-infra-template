import {handler} from "./index";
import {Event} from "./dto/Event";


const main = async () => {
    console.log("Starting test");

    const event = {
        input: "Test",
        num1: 2,
        num2: 3
    } as Event;

    const resp = await handler(event);
    console.log(resp);

};

main();


