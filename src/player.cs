using Godot;
using System;

enum MovementAction { idle, walk, run, jump, slide }

struct Directin
{
    public const int right = 1;
    public const int left = -1;
}

public class player : Node2D
{
    //nodes
    KinematicBody2D body;
    RayCast2D rayCast1;
    RayCast2D rayCast2;
    AudioStreamPlayer2D audioStreamPlayer;
    AnimationPlayer animationPlayer;

    //movement properties
    [Export] int speed = 280;
    [Export] float runningMultiplier = 1.3f;
    [Export] int jumpForce = 450;
    [Export] int gravityScale = 1200;
    [Export] int slideness = 10;
    [Export] public string idleAnimationName;
    [Export] public string walkAnimationName;
    [Export] public string slideAnimationName;
    [Export] public string runAnimationName;
    [Export] public string jumpAnimationName;
    [Export] public string crouchAnimationName;
    [Export] public AudioStream jumpAudioStream;
    [Export] public AudioStream slideAudioStream;
    [Export] public AudioStream walkAudioStream;

    //extends functions
    [Signal] public delegate void _AfterProcess(float delta);
    [Signal] public delegate void _BeforeProcess(float delta);
    [Signal] public delegate void _AfterReady(float delta);
    [Signal] public delegate void _AfterJump(float force);
    [Signal] public delegate void _AfterMove(float force);
    [Signal] public delegate void _onCollision(KinematicCollision2D collision);



    //movement variables
    Vector2 velocity = new Vector2();
    Vector2 up = new Vector2(0, -1); // for collision testing
    MovementAction currentAction = MovementAction.idle;

    public override void _Ready()
    {
        //get nodes
        body = GetNode<KinematicBody2D>("body");
        audioStreamPlayer = GetNode<AudioStreamPlayer2D>("audioStreamPlayer");
        animationPlayer = body.GetNode<AnimationPlayer>("sprite/animationPlayer");
        rayCast1 = body.GetNode<RayCast2D>("rayCast1");
        rayCast2 = body.GetNode<RayCast2D>("rayCast2");

        EmitSignal("_AfterReady");

    }

    public override void _Process(float delta)
    {
        EmitSignal("_BeforeProcess", delta);

        this.handleInput();// get velocity from input

        velocity.y += gravityScale * delta; //apply grvity 
        velocity += slide() * delta;
        if (velocity.x == 0 && body.IsOnFloor() && currentAction != MovementAction.slide)// is player is idle
        {
            currentAction = MovementAction.idle;
        }

        velocity = body.MoveAndSlide(velocity, up);
        KinematicCollision2D collision = body.MoveAndCollide(new Vector2());
        if (collision != null)
        {
            EmitSignal("_onCollision", collision);
        }
        updateVisuals();
        EmitSignal("_AfterProcess", delta);
    }

    public void handleInput()
    {
        if (Input.IsKeyPressed(16777217))// if esc pressed exit
        {
            GetTree().Quit();
        }
        move();
    }
    //movement
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
                divideBy++;
            }
            if (ground2 != null)
            {
                rotationDegrees += ground2.RotationDegrees;
                divideBy++;
            }
        }
        else
        {
            return new Vector2(0, 0);
        }

        rotationDegrees = rotationDegrees / divideBy;
        body.RotationDegrees = rotationDegrees;
        return new Vector2(1, 1) * (Mathf.Rad2Deg(rotationDegrees) * slideness); ;
    }

    public void move()
    {
        bool right = Input.IsActionPressed("player_right");
        bool left = Input.IsActionPressed("player_left");
        bool jump = Input.IsActionPressed("player_jump");
        bool run = Input.IsActionPressed("player_run");
        bool isonfloor = body.IsOnFloor();

        velocity.x = 0;

        if (jump && isonfloor)
        {
            actionJump();
        }


        if (right)
        {
            actionMove(Directin.right, run);
        }

        if (left)
        {
            actionMove(Directin.left, run);
        }

        return;

    }
    void actionJump()
    {
        currentAction = MovementAction.jump;
        velocity.y = -jumpForce;
        EmitSignal("_AfterJump", jumpForce);
    }
    void actionMove(int directin, bool isRunning)
    {
        if (isRunning)
        {
            if (body.IsOnFloor())
            {
                currentAction = MovementAction.run;
            }
            velocity.x += speed * directin * runningMultiplier;
            setAnimation(runAnimationName);
        }
        else
        {
            if (body.IsOnFloor())
            {
                currentAction = MovementAction.walk;
            }
            setAnimation(walkAnimationName);
            velocity.x += speed * directin;
        }

        EmitSignal("_AfterMove", speed * directin);
    }

    //visuals
    void updateVisuals()
    {
        switch (currentAction)
        {
            case MovementAction.idle:
                setAnimation(idleAnimationName);
                audioStreamPlayer.Stop();
                break;
            case MovementAction.walk:
                setAnimation(walkAnimationName);
                setAudio(walkAudioStream);
                break;
            case MovementAction.run:
                setAnimation(runAnimationName);
                setAudio(walkAudioStream);

                break;
            case MovementAction.slide:
                setAudio(slideAudioStream);
                break;
            case MovementAction.jump:
                setAnimation(jumpAnimationName);
                setAudio(jumpAudioStream);
                break;
        }
    }
    public void setAnimation(string animation)
    {
        if (animation != null && animationPlayer.CurrentAnimation != animation)
        {
            animationPlayer.SetCurrentAnimation(animation);
        }
    }
    public void setAudio(AudioStream audio)
    {
        if (audio != null && (audioStreamPlayer.Stream != audio || !audioStreamPlayer.IsPlaying()))
        {
            GD.Print(currentAction);
            audioStreamPlayer.Stream = audio;
            audioStreamPlayer.Play();
        }
    }
}
