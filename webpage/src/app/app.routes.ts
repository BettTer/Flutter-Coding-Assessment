import { Routes } from '@angular/router';
import { TicketsComponent } from './tickets/tickets';
import { EditorComponent } from './editor/editor';
import { LogsComponent } from './logs/logs';

export const routes: Routes = [
  { path: '', redirectTo: 'tickets', pathMatch: 'full' }, // default
  { path: 'tickets', component: TicketsComponent },
  { path: 'editor', component: EditorComponent },
  { path: 'logs', component: LogsComponent },
];