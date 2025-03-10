import { Injectable } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import { Connection } from 'mongoose';

@Injectable()
export class AppService {
  constructor(@InjectConnection() private readonly connection: Connection) {}

  getHello(): string {
    return 'Hello World!';
  }

  getHealthDB(): string {
    return this.connection.readyState === 1 ? 'Connected' : 'Disconnected';
  }
}
