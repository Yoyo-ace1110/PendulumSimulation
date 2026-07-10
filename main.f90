Program pendulum_simulation
    ! floating point precision
    use, intrinsic :: iso_fortran_env, only: dp=>real64
    implicit none
    ! static constexpr
    real(dp), parameter :: g  = 9.806_dp
    real(dp), parameter :: L  = 0.150_dp
    real(dp), parameter :: dt = 0.00001_dp
    real(dp), parameter :: pi = 3.14159265358979_dp
    real(dp), parameter :: theta0 = (30.0_dp) / 180.0_dp * pi
    real(dp), parameter :: k = sin(theta0/2.0_dp)
    real(dp), parameter :: sqrted_k = (k**2)
    ! declare variable
    real(dp) :: time, tmax, theta, omega, alpha, next_alpha
    ! initialize variable
    time  = 0.0_dp
    theta = theta0
    omega = 0.0_dp
    alpha = -(g/L)*sin(theta)
    tmax  = 5.0_dp * caculate_period(4)
    ! save datas in to a txt file
    open(unit=10, file='result.txt', status='unknown')
    write(10, '(A)') 'Time,Theta,Omega'
    ! main loop (for time)
    Do While (time <= tmax)
        ! 韋爾萊積分法
        call write_to_file()
        call print_variables()
        ! dθ = ω*dt + (1/2)*α*(dt)^2
        theta = theta + (omega * dt) + (0.5_dp * alpha * (dt**2))
        ! α = -sqrt(g/L) * sin(θ) 
        next_alpha = -(g/L) * sin(theta)
        ! dω = (1/2)*(α+α_next)*dt
        omega = omega + 0.5_dp * dt * (alpha + next_alpha)
        ! update alpha and time
        alpha = next_alpha
        time = time + dt
    End Do
Contains
    Subroutine write_to_file()
        write(10, '(SS, F11.8, A, F11.8, A, F11.8)') time, ',', theta, ',', omega
    End Subroutine write_to_file

    Subroutine print_variables()
        print *, 'time: ' , time
        print *, 'theta: ', theta
        print *, 'omega: ', omega
        print *, 'alpha: ', alpha
        print *, ''
    End Subroutine print_variables

    Function caculate_period(n) Result(T)
        real(dp) :: T
        integer  :: i
        integer, intent(in) :: n
        real(dp) :: sigma = 1.0_dp ! The sigma part of formula
        real(dp) :: term  = 1.0_dp ! The current term of sigma
        ! sigma = [ 1 + sigma{n=1}{inf}{ [k^(2n)] * [(2n-1)!! / (2n)!!] } ]
        Do i = 1, n
            ! term = term * [ k^n * (2n-1) / (2n)]^2
            term = term * sqrted_k * ((2.0_dp*i-1.0_dp)/(2.0_dp*i))**2
            sigma = sigma + term
        End Do
        T = 2.0_dp * pi * sqrt(L/g) * sigma
        ! T = 2*pi*sqrt(L/g)*[1 + (1/4)*(k^2) + (9/64)*(k^4)...]
        ! T = 2.0_dp*pi*sqrt(L/g) * (1.0_dp + (1.0_dp/4.0_dp)*(k**2) + (9.0_dp/64.0_dp)*(k**4))
    End Function caculate_period
End Program pendulum_simulation

! gfortran Pendulum\main.f90 -O3 -o "Pendulum\build\main.exe" -Wall -g -fcheck=all -std=f2008
