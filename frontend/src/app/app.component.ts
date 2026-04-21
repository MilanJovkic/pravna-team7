import { Component } from '@angular/core';
import { RouterModule, RouterOutlet } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterModule, RouterOutlet],
  template: `
    <div class="app">
      <nav class="navbar">
        <div class="nav-container">
          <h1 class="app-title">
            <a class="title-link" routerLink="/laws">Sistem za podršku u sudskom odlučivanju</a>
          </h1>
          <div class="nav-links">
            <a routerLink="/laws" routerLinkActive="active">Zakoni</a>
            <a routerLink="/verdicts" routerLinkActive="active">Presude</a>
            <a routerLink="/reasoning" routerLinkActive="active">Rasuđivanje</a>
          </div>
        </div>
      </nav>
      
      <main class="main-content">
        <router-outlet></router-outlet>
      </main>
    </div>
  `,
  styles: [`
    .app {
      min-height: 100vh;
      background: #f5f6fa;
    }
    
    .navbar {
      background: linear-gradient(135deg, #0f5c52 0%, #1b6f65 50%, #f4a261 100%);
      color: white;
      padding: 0;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    
    .nav-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    
    .app-title {
      margin: 0;
      font-size: 24px;
      font-weight: 600;
    }

    .title-link {
      color: white;
      text-decoration: none;
    }

    .title-link:hover {
      text-decoration: underline;
    }
    
    .nav-links {
      display: flex;
      gap: 30px;
    }
    
    .nav-links a {
      color: white;
      text-decoration: none;
      font-weight: 500;
      padding: 8px 16px;
      border-radius: 5px;
      transition: background 0.3s;
    }
    
    .nav-links a:hover {
      background: rgba(255,255,255,0.2);
    }
    
    .nav-links a.active {
      background: rgba(255,255,255,0.3);
    }
    
    .main-content {
      padding: 30px 20px;
    }
  `]
})
export class AppComponent {
  title = 'Sistem za podršku u sudskom odlučivanju';
}
