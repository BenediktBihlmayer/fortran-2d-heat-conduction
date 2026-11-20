program heat_conduction_2d
    implicit none
    
    ! Parameter definieren
    integer, parameter :: nx = 50, ny = 50 ! Gitterpunkte in x- und y-Richtung
    integer, parameter :: steps = 1000    ! Anzahl der Zeitschritte
    real(8), parameter :: Lx = 1.0_8, Ly = 1.0_8 ! Abmessungen der Platte
    real(8), parameter :: alpha = 0.01_8  ! Temperaturleitfähigkeit
    real(8) :: dx, dy, dt
    real(8) :: T(nx, ny), T_new(nx, ny)
    integer :: i, j, n

    ! Gitterabstände und sicheren Zeitschritt berechnen (CFL-Bedingung)
    dx = Lx / real(nx - 1, 8)
    dy = Ly / real(ny - 1, 8)
    dt = 0.25_8 * min(dx**2, dy**2) / alpha

    ! 1. Initialisierung: Starttemperatur überall 0 Grad
    T = 0.0_8
    
    ! Randbedingungen setzen: Linker Rand ist heiß (100 Grad)
    T(1, :) = 100.0_8

    ! 2. Hauptschleife (Time-Loop)
    do n = 1, steps
        T_new = T ! Alten Zustand kopieren

        ! Über alle inneren Gitterpunkte iterieren
        do i = 2, nx - 1
            do j = 2, ny - 1
                T_new(i, j) = T(i, j) + alpha * dt * ( &
                    (T(i+1, j) - 2.0_8 * T(i, j) + T(i-1, j)) / dx**2 + &
                    (T(i, j+1) - 2.0_8 * T(i, j) + T(i, j-1)) / dy**2   &
                )
            end do
        end do

        ! Zustand für den nächsten Schritt übernehmen
        T = T_new
        
        ! Fortschritt ausgeben
        if (mod(n, 200) == 0) then
            print *, "Zeitschritt abgeschlossen: ", n, " | Max Temp im Feld: ", maxval(T)
        end if
    end do

    print *, "Simulation erfolgreich beendet!"

end program heat_conduction_2d
