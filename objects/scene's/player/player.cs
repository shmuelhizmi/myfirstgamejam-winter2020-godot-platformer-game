using Godot;
using System;

public class player : Node2D
{
    //nodes
    KinematicBody2D body;
    RayCast2D rayCast1;
    RayCast2D rayCast2;
    AnimationPlayer animationPlayer;
    //movement properties
    [Export] int speed = 280;
    [Export] int jumpForce = 450;
    [Export] int gravityScale = 1200;
    [Export] int slideness = 10;


    //movement variables
    Vector2 velocity = new Vector2();
    Vector2 up = new Vector2(0, -1);
    bool isJumping = true;
    public override void _Ready()
    {
        //get nodes
        body = GetNode<KinematicBody2D>("body");
        animationPlayer = body.GetNode<AnimationPlayer>("sprite/animationPlayer");
        rayCast1 = body.GetNode<RayCast2D>("rayCast1");
        rayCast2 = body.GetNode<RayCast2D>("rayCast2");

    }

    public override void _Process(float delta)
    {
        this.handleInput();
        velocity.y += gravityScale * delta;
        if (isJumping && body.IsOnFloor())
        {
            isJumping = false;
        }
        velocity += slide() * delta;
        velocity = body.MoveAndSlide(velocity, up);
        KinematicCollision2D collision = body.MoveAndCollide(new Vector2());
    }

    public void handleInput()
    {
        if (Input.IsKeyPressed(16777217))
        {
            GetTree().Quit();
        }
        move();
    }
    public Vector2 slide()
    {
        Node2D ground1 = (Node2D)rayCast1.GetCollider();
        Node2D ground2 = (Node2D)rayCast2.GetCollider();
        float rotationDegrees = 0;
        int divideBy = 0;
        if (ground1 != null || ground2 != null)
        {
            if (ground1 != null)
            {
                rotationDegrees += ground1.RotationDegrees;
                GD.Print(rotationDegrees);
                divideBy++;
            }
            if (ground2 != null)
            {
                rotationDegrees += ground2.RotationDegrees;
                GD.Print(rotationDegrees);
                divideBy++;
            }
        }
        else
        {
            return new Vector2(0, 0);
        }

        rotationDegrees = rotationDegrees / divideBy;
        body.RotationDegrees = rotationDegrees;
        GD.Print((new Vector2(1, 1) * (Mathf.Rad2Deg(rotationDegrees) * slideness)));
        return new Vector2(1, 1) * (Mathf.Rad2Deg(rotationDegrees) * slideness); ;
    }

    public void move()
    {
        bool right = Input.IsActionPressed("player_right");
        bool left = Input.IsActionPressed("player_left");
        bool jump = Input.IsActionPressed("player_jump");
        bool isonfloor = body.IsOnFloor();

        velocity.x = 0;

        if (jump && isonfloor)
        {
            actionJump();
        }
        if (right)
        {
            actionMove(Directin.right);
        }

        if (left)
        {
            actionMove(Directin.left);
        }
        return;

    }
    void actionJump()
    {
        velocity.y = -jumpForce;
        isJumping = true;
    }
    void actionMove(int directin)
    {
        velocity.x += speed * directin;
    }
    struct Directin
    {
        public const int right = 1;
        public const int left = -1;
    }
}
