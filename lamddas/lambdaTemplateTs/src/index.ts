import config from "./config";
import { Response } from "./dto/Response";
import { Event } from "./dto/Event";

export const handler = async (event: Event): Promise<Response> => {
  console.log("Event: ", JSON.stringify(event), config.ENV);
  console.log("Prueba 1");
  const { num1, num2 } = event;
  const result = num1 + num2;
  console.log(`Sumando numeros: ${result}`);

  return {
    status: 200,
    message: "Success",
  };
};

